// MEGA65 DMA test using F018 directly
// Appendix J in https://mega.scryptos.com/sharefolder-link/MEGA/MEGA65+filehost/Docs/MEGA65-Book_draft.pdf
#pragma target(mega65)
#include <mega65.h>

void main() {
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    memoryRemap(0,0,0);
    // Enable enable F018B mode
    DMA->EN018B = 1;
    // Set address of DMA list
    DMA->ADDRMB = 0;
    DMA->ADDRBANK = 0;
    DMA-> ADDRMSB = >&DMA_SCREEN_UP;
    // Trigger the DMA (without option lists)
    DMA-> ADDRLSBTRIG = <&DMA_SCREEN_UP;
    // Re-enable F018A mode
    DMA->EN018B = 0;
}

// DMA list entry that scrolls the default screen up
struct DMA_LIST_F018B DMA_SCREEN_UP = {
    DMA_COMMAND_COPY,   // command
    24*80,              // count
    DEFAULT_SCREEN+80,  // source
    0,                  // source bank
    DEFAULT_SCREEN,     // destination
    0,                  // destination bank
    0,                  // sub-command
    0                   // modulo-value
};