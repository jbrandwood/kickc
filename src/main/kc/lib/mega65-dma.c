// Functions for using the F018 DMA for very fast copying or filling of memory
#include <mega65-dma.h>

// Copy a memory block within the first 64K memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest The destination address (within the MB and bank)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
void memcpy_dma(void* dest, void* src, unsigned int num) {
    // Remember current F018 A/B mode
    char dmaMode = DMA->EN018B;
    // Set up command
    memcpy_dma_command.count = num;
    memcpy_dma_command.src = src;
    memcpy_dma_command.dest = dest;
    // Set F018B mode
    DMA->EN018B = 1;
    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = >&memcpy_dma_command;
    // Trigger the DMA (without option lists)
    DMA-> ADDRLSBTRIG = <&memcpy_dma_command;
    // Re-enable F018A mode
    DMA->EN018B = dmaMode;
}

// DMA list entry for copying data
struct DMA_LIST_F018B memcpy_dma_command = {
    DMA_COMMAND_COPY,   // command
    0,                  // count
    0,                  // source
    0,                  // source bank
    0,                  // destination
    0,                  // destination bank
    0,                  // sub-command
    0                   // modulo-value
};

// Copy a memory block anywhere in first 4MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_bank The 64KB bank for the destination (0-63)
// - dest The destination address (within the MB and bank)
// - src_bank The 64KB bank for the source (0-63)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
void memcpy_dma4(char dest_bank, void* dest, char src_bank, void* src, unsigned int num) {
    // Remember current F018 A/B mode
    char dmaMode = DMA->EN018B;
    // Set up command
    memcpy_dma_command4.count = num;
    memcpy_dma_command4.src_bank = src_bank;
    memcpy_dma_command4.src = src;
    memcpy_dma_command4.dest_bank = dest_bank;
    memcpy_dma_command4.dest = dest;
    // Set F018B mode
    DMA->EN018B = 1;
    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = >&memcpy_dma_command4;
    // Trigger the DMA (without option lists)
    DMA-> ADDRLSBTRIG = <&memcpy_dma_command4;
    // Re-enable F018A mode
    DMA->EN018B = dmaMode;
}

// DMA list entry for copying data in the 1MB memory space
struct DMA_LIST_F018B memcpy_dma_command4 = {
    DMA_COMMAND_COPY,   // command
    0,                  // count
    0,                  // source
    0,                  // source bank
    0,                  // destination
    0,                  // destination bank
    0,                  // sub-command
    0                   // modulo-value
};

// Copy a memory block anywhere in the entire 256MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_mb The MB value for the destination (0-255)
// - dest_bank The 64KB bank for the destination (0-15)
// - dest The destination address (within the MB and bank)
// - src_mb The MB value for the source (0-255)
// - src_bank The 64KB bank for the source (0-15)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
void memcpy_dma256(char dest_mb, char dest_bank, void* dest, char src_mb, char src_bank, void* src, unsigned int num) {
    // Remember current F018 A/B mode
    char dmaMode = DMA->EN018B;
    // Set up command
    memcpy_dma_command256[1] = src_mb;
    memcpy_dma_command256[3] = dest_mb;
    struct DMA_LIST_F018B * f018b = (struct DMA_LIST_F018B *)(&memcpy_dma_command256[6]);
    f018b->count = num;
    f018b->src_bank = src_bank;
    f018b->src = src;
    f018b->dest_bank = dest_bank;
    f018b->dest = dest;
    // Set F018B mode
    DMA->EN018B = 1;
    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = >memcpy_dma_command256;
    // Trigger the DMA (with option lists)
    DMA-> ETRIG = <memcpy_dma_command256;
    // Re-enable F018A mode
    DMA->EN018B = dmaMode;
}

// DMA list entry with options for copying data in the 256MB memory space
// Contains DMA options options for setting MB followed by DMA_LIST_F018B struct.
char memcpy_dma_command256[] = {
    DMA_OPTION_SRC_MB, 0x00,         // Set MB of source address
    DMA_OPTION_DEST_MB, 0x00,        // Set MB of destination address
    DMA_OPTION_FORMAT_F018B,         // Use F018B list format
    DMA_OPTION_END,                  // End of options
                                     // struct DMA_LIST_F018B
    DMA_COMMAND_COPY,                // command
    0, 0,                            // count
    0, 0,                            // source
    0,                               // source bank
    0, 0,                            // destination
    0,                               // destination bank
    0,                               // sub-command
    0, 0                             // modulo-value
};


// Fill a memory block within the first 64K memory space using MEGA65 DMagic DMA
// Fills the values of num bytes at the destination with a single byte value.
// - dest The destination address (within the MB and bank)
// - fill The char to fill with
// - num The number of bytes to copy
void memset_dma(void* dest, char fill, unsigned int num) {
    // Remember current F018 A/B mode
    char dmaMode = DMA->EN018B;
    // Set up command
    memset_dma_command.count = num;
    memset_dma_command.src = (char*)fill;
    memset_dma_command.dest = dest;
    // Set F018B mode
    DMA->EN018B = 1;
    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = >&memset_dma_command;
    // Trigger the DMA (without option lists)
    DMA-> ADDRLSBTRIG = <&memset_dma_command;
    // Re-enable F018A mode
    DMA->EN018B = dmaMode;
}

// DMA list entry for filling data
struct DMA_LIST_F018B memset_dma_command = {
    DMA_COMMAND_FILL,   // command
    0,                  // count
    0,                  // source
    0,                  // source bank
    0,                  // destination
    0,                  // destination bank
    0,                  // sub-command
    0                   // modulo-value
};


// Set a memory block anywhere in the entire 256MB memory space using MEGA65 DMagic DMA
// Sets the values of num bytes to the memory block pointed to by destination.
// - dest_mb The MB value for the destination (0-255)
// - dest_bank The 64KB bank for the destination (0-15)
// - dest The destination address (within the MB and bank)
// - num The number of bytes to copy
void memset_dma256(char dest_mb, char dest_bank, void* dest, char fill, unsigned int num) {
    // Remember current F018 A/B mode
    char dmaMode = DMA->EN018B;
    // Set up command
    memset_dma_command256[1] = dest_mb;
    struct DMA_LIST_F018B * f018b = (struct DMA_LIST_F018B *)(&memset_dma_command256[4]);
    f018b->count = num;
    f018b->dest_bank = dest_bank;
    f018b->dest = dest;
    // Set fill byte
    f018b->src = (char*)fill;
    // Set F018B mode
    DMA->EN018B = 1;
    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = >memset_dma_command256;
    // Trigger the DMA (with option lists)
    DMA-> ETRIG = <memset_dma_command256;
    // Re-enable F018A mode
    DMA->EN018B = dmaMode;
}

// DMA list entry with options for setting data in the 256MB memory space
// Contains DMA options options for setting MB followed by DMA_LIST_F018B struct.
char memset_dma_command256[] = {
    DMA_OPTION_DEST_MB, 0x00,        // Set MB of destination address
    DMA_OPTION_FORMAT_F018B,         // Use F018B list format
    DMA_OPTION_END,                  // End of options
                                     // struct DMA_LIST_F018B
    DMA_COMMAND_FILL,                // command
    0, 0,                            // count
    0, 0,                            // source
    0,                               // source bank
    0, 0,                            // destination
    0,                               // destination bank
    0,                               // sub-command
    0, 0                             // modulo-value
};