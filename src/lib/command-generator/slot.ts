import { LuaTweakType } from '@/types/types';

/**
 * Formats slot name for custom tweaks.
 * Uses numbered slots (1-9) since slot 0 is used by packed sources.
 */
export function formatSlotName(type: LuaTweakType, slotNumber: number): string {
    return slotNumber === 0 ? type : `${type}${slotNumber}`;
}
