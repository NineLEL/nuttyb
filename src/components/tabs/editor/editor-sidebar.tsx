import { useMemo, useState } from 'react';

import {
    Badge,
    Group,
    Paper,
    ScrollArea,
    SegmentedControl,
    Stack,
    Text,
    TextInput,
} from '@mantine/core';
import { IconSearch } from '@tabler/icons-react';

import { FileListItem } from '@/components/tabs/editor/file-list-item';
import { SlotListItem } from '@/components/tabs/editor/slot-list-item';
import type { SlotContent } from '@/hooks/use-slot-contents';
import type { LuaFile } from '@/types/types';

type ViewMode = 'sources' | 'slots';

interface EditorSidebarProps {
    viewMode: ViewMode;
    onViewModeChange: (mode: ViewMode) => void;
    luaFiles: LuaFile[];
    slotContents: SlotContent[];
    selectedFile: string | null;
    selectedSlot: string | null;
    onSelectFile: (path: string) => void;
    onSelectSlot: (slotName: string) => void;
    isFileModified: (path: string) => boolean;
    isSlotModified: (slotName: string) => boolean;
    getSlotSize: (slotName: string) => number;
    modifiedFileCount: number;
    modifiedSlotCount: number;
}

export function EditorSidebar({
    viewMode,
    onViewModeChange,
    luaFiles,
    slotContents,
    selectedFile,
    selectedSlot,
    onSelectFile,
    onSelectSlot,
    isFileModified,
    isSlotModified,
    getSlotSize,
    modifiedFileCount,
    modifiedSlotCount,
}: EditorSidebarProps) {
    const [searchQuery, setSearchQuery] = useState('');

    const filteredFiles = useMemo(() => {
        if (!searchQuery) return luaFiles;
        const query = searchQuery.toLowerCase();
        return luaFiles.filter((file) =>
            file.path.toLowerCase().includes(query)
        );
    }, [luaFiles, searchQuery]);

    const filteredSlots = useMemo(() => {
        if (!searchQuery) return slotContents;
        const query = searchQuery.toLowerCase();
        return slotContents.filter(
            (slot) =>
                slot.slotName.toLowerCase().includes(query) ||
                slot.sources.some((s) => s.toLowerCase().includes(query))
        );
    }, [slotContents, searchQuery]);

    return (
        <Paper withBorder p='sm' style={{ width: 280, flexShrink: 0 }}>
            <Stack gap='sm' style={{ height: '100%' }}>
                <SegmentedControl
                    size='xs'
                    value={viewMode}
                    onChange={(value) => onViewModeChange(value as ViewMode)}
                    data={[
                        { label: 'Source Files', value: 'sources' },
                        { label: 'Slot Content', value: 'slots' },
                    ]}
                />

                <Group justify='space-between'>
                    <Text fw={600} size='sm'>
                        {viewMode === 'sources' ? 'Files' : 'Slots'}
                    </Text>
                    {viewMode === 'sources' && modifiedFileCount > 0 && (
                        <Badge size='sm' color='yellow'>
                            {modifiedFileCount} modified
                        </Badge>
                    )}
                    {viewMode === 'slots' && modifiedSlotCount > 0 && (
                        <Badge size='sm' color='yellow'>
                            {modifiedSlotCount} modified
                        </Badge>
                    )}
                </Group>

                <TextInput
                    placeholder={
                        viewMode === 'sources'
                            ? 'Search files...'
                            : 'Search slots...'
                    }
                    size='xs'
                    leftSection={<IconSearch size={14} />}
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.currentTarget.value)}
                />

                <ScrollArea style={{ flex: 1 }}>
                    <Stack gap={2}>
                        {viewMode === 'sources'
                            ? filteredFiles.map((file) => (
                                  <FileListItem
                                      key={file.path}
                                      fileName={file.path.split('/').pop()!}
                                      isSelected={selectedFile === file.path}
                                      isModified={isFileModified(file.path)}
                                      onClick={() => onSelectFile(file.path)}
                                  />
                              ))
                            : filteredSlots.map((slot) => (
                                  <SlotListItem
                                      key={slot.slotName}
                                      slotName={slot.slotName}
                                      slotType={slot.type}
                                      sources={slot.sources}
                                      isSelected={
                                          selectedSlot === slot.slotName
                                      }
                                      isModified={isSlotModified(slot.slotName)}
                                      slotSize={getSlotSize(slot.slotName)}
                                      onClick={() =>
                                          onSelectSlot(slot.slotName)
                                      }
                                  />
                              ))}
                    </Stack>
                </ScrollArea>
            </Stack>
        </Paper>
    );
}
