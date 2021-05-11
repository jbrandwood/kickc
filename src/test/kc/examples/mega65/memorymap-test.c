// Test the MAP instruction for remapping memory
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// See Appendix G in https://mega.scryptos.com/sharefolder-link/MEGA/MEGA65+filehost/Docs/MEGA65-Book_draft.pdf for a description of the CPU memory remapper of the MEGA65.
#pragma target(mega65)
#include <mega65.h>

void main() {
    char * BLOCK_4000 = (char*)0x4000;
    char * BLOCK_8000 = (char*)0x8000;

    // Remap [$4000-$5fff] to point to [$10000-$11fff]
    memoryRemapBlock(0x40, 0x100);
    // Put '-', '*' into $10000
    BLOCK_4000[0] = '-';
    BLOCK_4000[1] = '*';

    // Remap [$8000-$9fff] to point to [$10000-$11fff]
    memoryRemapBlock(0x80, 0x100);
    // Put '-', '*' into $10002
    BLOCK_8000[2] = '-';
    BLOCK_8000[3] = '*';

    // Remap [$4000-$5fff] and [$8000-$9fff] to both point to [$10000-$11fff] (notice usage of page offsets)
    memoryRemap(MEMORYBLOCK_4000|MEMORYBLOCK_8000, 0x0c0, 0x080);
    // Put '-', '*' into $10004 in a convoluted way
    BLOCK_8000[4] = BLOCK_4000[2];
    BLOCK_4000[5] = BLOCK_8000[1];

    // copy the resulting values onto the screen - it should show '-*-*-*'
    for(char i=0;i<6;i++)
        (DEFAULT_SCREEN+80-6)[i] = BLOCK_4000[i];

    // Remap [$4000-$5fff] to point to [$ff80000-$ff81fff] COLORRAM! (notice usage of page offsets)
    memoryRemap256M(MEMORYBLOCK_4000, 0xff800-0x00040, 0);
    // Put colors in the upper screen line
    for( char i=0; i<16; i++) 
        BLOCK_4000[i] = 0x40+i;

    // Remap [$4000-$5fff] back to normal memory!
    memoryRemap256M(0, 0, 0);

}

// Test more corner case behaviors
// - [DONE] Mapping two blocks to the same memory : [$4000-$5fff] >> [$10000-$12000], [$8000-$9fff] >> [$10000-$12000]
// - Mapping two blocks to overlapping memory : [$4000-$5fff] >> [$10000-$12000], [$6000-$7f00] >> [$11000-$12ff]
// - Mapping a block to the 1MB border : [$4000-$5fff] >> [$ff000-$100fff] or [$ff000-$00fff] ?
// - Mapping a block over zeropage : [$0000-$1fff] >> [$10000-$12000]. Does zp-addressing-mode access the mapped memory? 



