// MEGA65 DMA test using memset
// Appendix J in https://mega.scryptos.com/sharefolder-link/MEGA/MEGA65+filehost/Docs/MEGA65-Book_draft.pdf
#pragma target(mega65)
#include <mega65-dma.h>
#include <6502.h>

void main() {
    // Map memory to BANK 0 : 0x00XXXX - giving access to I/O
    memoryRemap(0,0,0);
    // Fill screen up using DMA
    memset_dma(DEFAULT_SCREEN, '*',  80*10);    


}
