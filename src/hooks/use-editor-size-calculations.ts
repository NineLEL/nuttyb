import { useMemo } from 'react';

import { encode } from '@/lib/encoders/base64';
import { minify } from '@/lib/lua-utils/minificator';

interface UseEditorSizeCalculationsProps {
    getCurrentContent: (path: string) => string;
    getSlotContent: (slotName: string) => string;
}

export function useEditorSizeCalculations({
    getCurrentContent,
    getSlotContent,
}: UseEditorSizeCalculationsProps) {
    // Slot size calculation
    const getSlotB64Size = useMemo(
        () =>
            (slotName: string): number => {
                try {
                    const content = getSlotContent(slotName);
                    return encode(minify(content.trim())).length;
                } catch {
                    const content = getSlotContent(slotName);
                    return encode(content.trim()).length;
                }
            },
        [getSlotContent]
    );

    // File size calculation
    const getFileB64Size = useMemo(
        () =>
            (path: string): number => {
                try {
                    const content = getCurrentContent(path);
                    return encode(minify(content.trim())).length;
                } catch {
                    const content = getCurrentContent(path);
                    return encode(content.trim()).length;
                }
            },
        [getCurrentContent]
    );

    return {
        getSlotB64Size,
        getFileB64Size,
    };
}
