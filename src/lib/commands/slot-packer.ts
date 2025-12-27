import { encode } from '../base64';
import { formatSlotName } from './custom-tweaks';
import {
    MAX_COMMAND_LENGTH,
    MAX_SLOTS_PER_TYPE,
    TARGET_SLOT_SIZE,
} from '../data/configuration-mapping';
import { extractTopComments, stripCommentPrefix } from '../lua-comments';

/**
 * Base64 encoding overhead estimate (~37% expansion + padding).
 * Conservative multiplier to avoid exceeding TARGET_SLOT_SIZE after encoding.
 */
const BASE64_OVERHEAD_MULTIPLIER = 1.4;

/**
 * Metadata tracking which source files went into which slots.
 */
export interface SourcePlacement {
    path: string;
    priority: number;
    slotIndex: number;
}

/**
 * Result of packing Lua sources into slots with metadata.
 */
export interface SlotPackingResult {
    commands: string[];
    slotUsage: {
        used: number;
        total: number;
    };
    sourceMap?: SourcePlacement[];
}

/**
 * A Lua source with its path and priority for packing.
 */
export interface LuaSourceWithMetadata {
    path: string;
    content: string;
    priority: number;
}

/**
 * Internal slot builder for tracking contents during packing.
 */
interface SlotBuilder {
    sources: LuaSourceWithMetadata[];
    wrappedSources: string[];
    estimatedSize: number;
    maxPriority: number;
}

/**
 * Wraps Lua source in an IIFE (Immediately Invoked Function Expression).
 * Each file runs in its own scope to prevent variable collisions.
 * Includes source path comment for debugging.
 *
 * @param content Lua source code
 * @param path Source file path for debugging comment
 * @returns IIFE-wrapped Lua code with source comment
 */
function wrapInIIFE(content: string, path: string): string {
    return `-- Source: ${path}
(function()
${content}
end)()`;
}

/**
 * Creates a new empty slot builder.
 */
function createSlotBuilder(): SlotBuilder {
    return {
        sources: [],
        wrappedSources: [],
        estimatedSize: 0,
        maxPriority: -1,
    };
}

/**
 * Estimates encoded size including Base64 overhead.
 *
 * @param content Lua content to estimate size for
 * @returns Estimated size in bytes after Base64 encoding
 */
function estimateSize(content: string): number {
    const byteLength = Buffer.byteLength(content, 'utf8');
    return byteLength * BASE64_OVERHEAD_MULTIPLIER;
}

/**
 * Checks if a source can be added to a slot without violating constraints.
 *
 * @param slot Slot builder to check
 * @param slotIndex Index of the slot in the slots array
 * @param source Source to potentially add
 * @param wrappedSize Estimated size of wrapped source
 * @param slots All existing slots (to check ordering constraints)
 * @returns True if source can be added to slot
 */
function canAddToSlot(
    slot: SlotBuilder,
    slotIndex: number,
    source: LuaSourceWithMetadata,
    wrappedSize: number,
    slots: readonly SlotBuilder[]
): boolean {
    // Size constraint: must fit within target size
    if (slot.estimatedSize + wrappedSize > TARGET_SLOT_SIZE) {
        return false;
    }

    // Append-only within slot: source priority must be >= slot's max priority
    if (source.priority < slot.maxPriority) {
        return false;
    }

    // Global ordering constraint: ensure priority order across all slots
    // - Earlier slots (j < slotIndex): must have maxPriority <= source.priority
    // - Later slots (j > slotIndex): must have maxPriority >= source.priority
    for (const [j, otherSlot] of slots.entries()) {
        if (j === slotIndex) continue;

        if (j < slotIndex) {
            // Earlier slot: its max priority should be <= source priority
            if (otherSlot.maxPriority > source.priority) {
                return false;
            }
        } else {
            // Later slot: its max priority should be >= source priority
            if (otherSlot.maxPriority < source.priority) {
                return false;
            }
        }
    }

    return true;
}

/**
 * Adds a source to a slot builder.
 *
 * @param slot Slot builder to add to
 * @param source Source metadata
 * @param wrapped IIFE-wrapped Lua content
 * @param wrappedSize Estimated size of wrapped content
 */
function addSourceToSlot(
    slot: SlotBuilder,
    source: LuaSourceWithMetadata,
    wrapped: string,
    wrappedSize: number
): void {
    slot.sources.push(source);
    slot.wrappedSources.push(wrapped);
    slot.estimatedSize += wrappedSize;
    slot.maxPriority = Math.max(slot.maxPriority, source.priority);
}

/**
 * Finds the best-fit slot for a source (tightest fit among valid slots).
 * Best-fit: Choose slot with least remaining space after adding source.
 *
 * @param slots Array of slot builders
 * @param source Source to find slot for
 * @param wrappedSize Estimated size of wrapped source
 * @returns Best-fit slot or null if no valid slot exists
 */
function findBestFitSlot(
    slots: SlotBuilder[],
    source: LuaSourceWithMetadata,
    wrappedSize: number
): SlotBuilder | null {
    let bestSlot: SlotBuilder | null = null;
    let minRemainingSpace = Infinity;

    for (const [index, slot] of slots.entries()) {
        if (canAddToSlot(slot, index, source, wrappedSize, slots)) {
            const remainingSpace =
                TARGET_SLOT_SIZE - slot.estimatedSize - wrappedSize;
            if (remainingSpace < minRemainingSpace) {
                minRemainingSpace = remainingSpace;
                bestSlot = slot;
            }
        }
    }

    return bestSlot;
}

/**
 * Builds a merged header from source descriptions.
 * Extracts first-line comments from each source and combines them.
 *
 * @param sources Sources to extract descriptions from
 * @returns Merged header comment or undefined if no descriptions found
 */
function buildMergedHeader(
    sources: readonly LuaSourceWithMetadata[]
): string | undefined {
    const descriptions = sources
        .map((source) => {
            const topComments = extractTopComments(source.content);
            const firstLine = topComments.split('\n')[0] ?? '';
            return stripCommentPrefix(firstLine);
        })
        .filter((desc) => desc.length > 0);

    return descriptions.length > 0
        ? `-- ${descriptions.join(', ')}\n\n`
        : undefined;
}

/**
 * Packs sources using single-pass best-fit algorithm.
 * Sources are processed in priority order (0 -> 99).
 * For each source, find the best-fit slot among existing slots.
 *
 * Algorithm:
 * 1. Sort sources by priority (ascending)
 * 2. For each source:
 *    a. Find best-fit slot (tightest fit among valid slots)
 *    b. If found, add to that slot
 *    c. Otherwise, create new slot
 *
 * Priority constraint: Sources can only be added to slots where
 * source.priority >= slot.maxPriority (append-only for ordering).
 *
 * @param sources Array of Lua sources with metadata
 * @returns Array of slot builders with packed contents
 */
function packSources(sources: readonly LuaSourceWithMetadata[]): SlotBuilder[] {
    // Sort by priority (ascending: 0 -> 99)
    const sortedSources = [...sources].toSorted(
        (a, b) => a.priority - b.priority
    );
    const slots: SlotBuilder[] = [];

    for (const source of sortedSources) {
        const wrapped = wrapInIIFE(source.content, source.path);
        const wrappedSize = estimateSize(wrapped);

        // Find best-fit slot (tightest fit among valid slots)
        const bestSlot = findBestFitSlot(slots, source, wrappedSize);

        if (bestSlot) {
            addSourceToSlot(bestSlot, source, wrapped, wrappedSize);
        } else {
            // No valid slot found - create new slot
            const newSlot = createSlotBuilder();
            addSourceToSlot(newSlot, source, wrapped, wrappedSize);
            slots.push(newSlot);
        }
    }

    return slots;
}

/**
 * Packs multiple Lua sources into optimized slots using IIFE wrapping.
 * Single Responsibility: Orchestrates the packing process.
 *
 * This is the main entry point for multi-file IIFE packing. It:
 * 1. Packs sources using single-pass best-fit algorithm
 * 2. Generates !bset commands with validation
 * 3. Returns commands with slot usage metadata and source map
 *
 * @param sources Array of Lua sources with paths and priorities
 * @param slotType Either 'tweakdefs' or 'tweakunits'
 * @returns Commands, slot usage metadata, and source placement map
 * @throws Error if slot limit exceeded or command too large
 */
export function packLuaSourcesIntoSlots(
    sources: readonly LuaSourceWithMetadata[],
    slotType: 'tweakdefs' | 'tweakunits'
): SlotPackingResult {
    if (sources.length === 0) {
        return {
            commands: [],
            slotUsage: {
                used: 0,
                total: MAX_SLOTS_PER_TYPE,
            },
            sourceMap: [],
        };
    }

    // Pack sources using single-pass best-fit
    const slots = packSources(sources);

    // Check slot limit
    if (slots.length > MAX_SLOTS_PER_TYPE) {
        throw new Error(
            `Too many ${slotType} slots needed (${slots.length}). ` +
                `Maximum is ${MAX_SLOTS_PER_TYPE} slots. Please disable some settings to reduce slot usage.`
        );
    }

    // Generate !bset commands and build source map
    const commands: string[] = [];
    const sourceMap: SourcePlacement[] = [];

    for (const [slotIndex, slot] of slots.entries()) {
        // Build merged header
        const mergedHeader = buildMergedHeader(slot.sources);
        const slotContent = mergedHeader
            ? mergedHeader + slot.wrappedSources.join('\n\n')
            : slot.wrappedSources.join('\n\n');

        const encoded = encode(slotContent);
        const slotName = formatSlotName(slotType, slotIndex);
        const command = `!bset ${slotName} ${encoded}`;

        // Validate command length
        if (command.length > MAX_COMMAND_LENGTH) {
            console.error(
                `CRITICAL: ${slotType} slot ${slotIndex} exceeds MAX_COMMAND_LENGTH!\n` +
                    `Command is ${command.length} chars, limit is ${MAX_COMMAND_LENGTH}.`
            );
            throw new Error(
                `${slotType} slot ${slotIndex} exceeds ${MAX_COMMAND_LENGTH} char limit (${command.length} chars). ` +
                    'Please disable some settings to reduce slot usage.'
            );
        }

        commands.push(command);

        // Track source placements
        for (const source of slot.sources) {
            sourceMap.push({
                path: source.path,
                priority: source.priority,
                slotIndex,
            });
        }
    }

    return {
        commands,
        slotUsage: {
            used: commands.length,
            total: MAX_SLOTS_PER_TYPE,
        },
        sourceMap,
    };
}
