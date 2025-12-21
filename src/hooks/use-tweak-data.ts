'use client';

import { useMemo } from 'react';

import { buildLobbySections } from '@/lib/commands/command-builder';
import type { EnabledCustomTweak } from '@/lib/commands/custom-tweaks';
import type { Configuration } from '@/lib/configuration';
import type { LuaFile } from '@/types/types';

export interface UseTweakDataReturn {
    sections: string[];
    slotUsage?: {
        tweakdefs: { used: number; total: number };
        tweakunits: { used: number; total: number };
    };
    error?: string;
}

export function useTweakData(
    configuration: Configuration,
    luaFiles: LuaFile[],
    enabledCustomTweaks?: EnabledCustomTweak[]
): UseTweakDataReturn {
    const result = useMemo<UseTweakDataReturn>(() => {
        if (luaFiles.length === 0) {
            return { sections: [] };
        }

        try {
            const { sections, slotUsage } = buildLobbySections(
                configuration,
                luaFiles,
                enabledCustomTweaks
            );
            return { sections, slotUsage };
        } catch (error) {
            console.error('[useTweakData] Failed to build commands:', error);
            return {
                sections: [],
                error:
                    error instanceof Error
                        ? error.message
                        : 'Failed to generate commands',
            };
        }
    }, [configuration, luaFiles, enabledCustomTweaks]);

    return result;
}
