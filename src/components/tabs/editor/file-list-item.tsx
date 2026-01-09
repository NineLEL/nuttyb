import { Badge, Box, Group, Text } from '@mantine/core';
import { IconFile } from '@tabler/icons-react';

interface FileListItemProps {
    fileName: string;
    isSelected: boolean;
    isModified: boolean;
    onClick: () => void;
}

export function FileListItem({
    fileName,
    isSelected,
    isModified,
    onClick,
}: FileListItemProps) {
    return (
        <Box
            p='xs'
            style={{
                cursor: 'pointer',
                borderRadius: 4,
                backgroundColor: isSelected
                    ? 'var(--mantine-color-blue-9)'
                    : 'transparent',
            }}
            onClick={onClick}
        >
            <Group gap='xs' wrap='nowrap'>
                <IconFile size={14} />
                <Text size='sm' truncate style={{ flex: 1 }}>
                    {fileName}
                </Text>
                {isModified && <Badge size='xs' color='yellow' variant='dot' />}
            </Group>
        </Box>
    );
}
