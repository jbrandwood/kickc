// C64 DTV version 2 Registers and Constants
//
// Sources
// (J) https://www.c64-wiki.com/wiki/C64DTV_Programming_Guide
// (H) http://dtvhacking.cbm8bit.com/dtv_wiki/images/d/d9/Dtv_registers_full.txt

#include <c64dtv.h>

// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
void dtvSetCpuBankSegment1(char cpuBankIdx) {
    // Move CPU BANK 1 SEGMENT ($4000-$7fff)
    char* cpuBank = (char*)$ff;
    *cpuBank = cpuBankIdx;
    asm {
        // SAC $dd - A register points to 13 BANK 1 segment
        .byte $32, $dd
        // LDA $ff - Set CPU BANK 1 SEGMENT ($4000-$7fff) to ($ff)*$4000
        lda $ff
        // SAC $00 - A register points to 0 ACCUMULATOR
        .byte $32, $00
    }
}
