// Functions for using the F018 DMA for very fast copying or filling of memory
#include <mega65.h>

// Copy a memory block within the first 64K memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly
// to the memory block pointed to by destination.
// The underlying type of the objects pointed to by both the source and destination pointers
// are irrelevant for this function; The result is a binary copy of the data.
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