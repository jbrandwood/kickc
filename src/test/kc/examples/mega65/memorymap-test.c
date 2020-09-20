// Test the MAP instruction for remapping memory
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// See Appendix G in file:///Users/jespergravgaard/Downloads/MEGA65-Book_draft%20(5).pdf for a description of the CPU memory remapper of the MEGA65.
#pragma target(mega65)
#include <mega65.h>

void main() {
    char * block1 = 0x4000;
    char * block2 = 0x8000;

    // Remap [$4000-$5fff] to point to [$10000-$11fff]
    memoryRemapBlock(0x40, 0x100);
    // Put 0x55, 0xaa into $10000
    block1[0] = 0x55;
    block1[1] = 0xaa;

    // Remap [$8000-$9fff] to point to [$10000-$11fff]
    memoryRemapBlock(0x80, 0x100);
    // Put 0x55, 0xaainto $10002
    block2[2] = 0x55;
    block2[3] = 0xaa;

    // Remap [$4000-$5fff] and [$8000-$9fff] to both point to [$10000-$11fff] (notice usage of page offsets)
    memoryRemap(MEMORYBLOCK_4000|MEMORYBLOCK_8000, 0x0c0, 0x080);
    // Put 0x55, 0xaa into $10004 in a convoluted way
    block2[4] = block1[2];
    block1[5] = block2[1];

    // Remap [$4000-$5fff] to both point to [$ff80000-$ff81fff] COLORAM! (notice usage of page offsets)
    memoryRemap256M(MEMORYBLOCK_4000, 0xff800-0x00040, 0);
    // Put colors in the upper left corner!
    block1[0] = 0;
    block1[1] = 1;

    // Remap [$4000-$5fff] back to normal memory!
    memoryRemap256M(0, 0, 0);

}


// Bit representing 8K block #0 of the 64K addressable memory ($0000-$1fff)
const unsigned char MEMORYBLOCK_0000 = 0b00000001;
// Bit representing 8K block #1 of the 64K addressable memory ($2000-$3fff)
const unsigned char MEMORYBLOCK_2000 = 0b00000010;
// Bit representing 8K block #2 of the 64K addressable memory ($4000-$5fff)
const unsigned char MEMORYBLOCK_4000 = 0b00000100;
// Bit representing 8K block #3 of the 64K addressable memory ($6000-$7fff)
const unsigned char MEMORYBLOCK_6000 = 0b00001000;
// Bit representing 8K block #4 of the 64K addressable memory ($8000-$9fff)
const unsigned char MEMORYBLOCK_8000 = 0b00010000;
// Bit representing 8K block #5 of the 64K addressable memory ($a000-$bfff)
const unsigned char MEMORYBLOCK_A000 = 0b00100000;
// Bit representing 8K block #6 of the 64K addressable memory ($c000-$dfff)
const unsigned char MEMORYBLOCK_C000 = 0b01000000;
// Bit representing 8K block #7 of the 64K addressable memory ($e000-$ffff)
const unsigned char MEMORYBLOCK_E000 = 0b10000000;

// Remap some of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access a remapped block.
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// remapBlocks: Indicates which 8K blocks of the 6502 address space to remap. Each bit represents one 8K block
// - bit 0  Memory block $0000-$1fff. Use constant MEMORYBLOCK_0000. 
// - bit 1  Memory block $2000-$3fff. Use constant MEMORYBLOCK_2000. 
// - bit 2  Memory block $4000-$5fff. Use constant MEMORYBLOCK_4000. 
// - bit 3  Memory block $6000-$7fff. Use constant MEMORYBLOCK_6000. 
// - bit 4  Memory block $8000-$9fff. Use constant MEMORYBLOCK_8000. 
// - bit 5  Memory block $a000-$bfff. Use constant MEMORYBLOCK_A000. 
// - bit 6  Memory block $c000-$dfff. Use constant MEMORYBLOCK_C000. 
// - bit 7  Memory block $e000-$ffff. Use constant MEMORYBLOCK_E000. 
// lowerPageOffset: Offset that will be added to any remapped blocks in the lower 32K of memory (block 0-3). 
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 0 ($0000-$1fff) is remapped it will point to lowerPageOffset*$100.  
// - If block 1 ($2000-$3fff) is remapped it will point to lowerPageOffset*$100 + $2000.  
// - If block 2 ($4000-$5fff) is remapped it will point to lowerPageOffset*$100 + $4000.  
// - If block 3 ($6000-$7fff) is remapped it will point to lowerPageOffset*$100 + $6000.  
// upperPageOffset: Offset that will be added to any remapped blocks in the upper 32K of memory (block 4-7). 
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 12bits of the passed value is used.
// - If block 4 ($8000-$9fff) is remapped it will point to upperPageOffset*$100 + $8000  
// - If block 5 ($a000-$bfff) is remapped it will point to upperPageOffset*$100 + $a000.  
// - If block 6 ($c000-$dfff) is remapped it will point to upperPageOffset*$100 + $c000.  
// - If block 7 ($e000-$ffff) is remapped it will point to upperPageOffset*$100 + $e000.  
void memoryRemap(unsigned char remapBlocks, unsigned int lowerPageOffset, unsigned int upperPageOffset) {
    char * aVal = 0xfc;
    char * xVal = 0xfd;
    char * yVal = 0xfe;
    char * zVal = 0xff;
    *aVal = <lowerPageOffset;
    *xVal = (remapBlocks << 4)   | (>lowerPageOffset & 0xf);
    *yVal = <upperPageOffset;
    *zVal = (remapBlocks & 0xf0) | (>upperPageOffset & 0xf);
    asm {
        lda aVal    // lower blocks offset page low
        ldx xVal    // lower blocks to map + lower blocks offset high nibble
        ldy yVal    // upper blocks offset page
        ldz zVal    // upper blocks to map + upper blocks offset page high nibble
        map
        eom
    }
}

// Remap a single 8K memory block in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// All the other 8K memory blocks will not be mapped and will point to their own address in the lowest 64K of the MEGA65 memory.
// blockPage: Page address of the 8K memory block to remap (ie. the block that is remapped is $100 * the passed page address.) 
// memoryPage: Page address of the memory that the block should point to in the 1MB memory space of the MEGA65. 
// Ie. the memory that will be pointed to is $100 * the passed page address. Only the lower 12bits of the passed value is used.
void memoryRemapBlock(unsigned char blockPage, unsigned int memoryPage) {
    // Find the page offset (the number of pages to offset the block)
    unsigned int pageOffset = memoryPage-blockPage;
    // Which block is being remapped? (0-7)
    char block = blockPage / $20;
    char blockBits = 1<<block;
    memoryRemap(blockBits, pageOffset, pageOffset);
}

// Remap some of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the entire 256MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access a remapped block.
// See section 2.3.4 in http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt for a description of the CPU memory remapper of the C65.
// See Appendix G in file:///Users/jespergravgaard/Downloads/MEGA65-Book_draft%20(5).pdf for a description of the CPU memory remapper of the MEGA65.
// remapBlocks: Indicates which 8K blocks of the 6502 address space to remap. Each bit represents one 8K block
// - bit 0  Memory block $0000-$1fff. Use constant MEMORYBLOCK_0000. 
// - bit 1  Memory block $2000-$3fff. Use constant MEMORYBLOCK_2000. 
// - bit 2  Memory block $4000-$5fff. Use constant MEMORYBLOCK_4000. 
// - bit 3  Memory block $6000-$7fff. Use constant MEMORYBLOCK_6000. 
// - bit 4  Memory block $8000-$9fff. Use constant MEMORYBLOCK_8000. 
// - bit 5  Memory block $a000-$bfff. Use constant MEMORYBLOCK_A000. 
// - bit 6  Memory block $c000-$dfff. Use constant MEMORYBLOCK_C000. 
// - bit 7  Memory block $e000-$ffff. Use constant MEMORYBLOCK_E000. 
// lowerPageOffset: Offset that will be added to any remapped blocks in the lower 32K of memory (block 0-3). 
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 20bits of the passed value is used.
// - If block 0 ($0000-$1fff) is remapped it will point to lowerPageOffset*$100.  
// - If block 1 ($2000-$3fff) is remapped it will point to lowerPageOffset*$100 + $2000.  
// - If block 2 ($4000-$5fff) is remapped it will point to lowerPageOffset*$100 + $4000.  
// - If block 3 ($6000-$7fff) is remapped it will point to lowerPageOffset*$100 + $6000.  
// upperPageOffset: Offset that will be added to any remapped blocks in the upper 32K of memory (block 4-7). 
// The offset is a page offset (meaning it is multiplied by 0x100). Only the lower 20bits of the passed value is used.
// - If block 4 ($8000-$9fff) is remapped it will point to upperPageOffset*$100 + $8000  
// - If block 5 ($a000-$bfff) is remapped it will point to upperPageOffset*$100 + $a000.  
// - If block 6 ($c000-$dfff) is remapped it will point to upperPageOffset*$100 + $c000.  
// - If block 7 ($e000-$ffff) is remapped it will point to upperPageOffset*$100 + $e000.  
void memoryRemap256M(unsigned char remapBlocks, unsigned long lowerPageOffset, unsigned long upperPageOffset) {
    char * lMb = 0xfa;
    char * uMb = 0xfb;
    char * aVal = 0xfc;
    char * xVal = 0xfd;
    char * yVal = 0xfe;
    char * zVal = 0xff;
    *lMb = >((unsigned int)(lowerPageOffset>>4));
    *uMb = >((unsigned int)(upperPageOffset>>4));
    *aVal = < <lowerPageOffset;
    *xVal = (remapBlocks << 4)   | (> <lowerPageOffset & 0xf);
    *yVal = < <upperPageOffset;
    *zVal = (remapBlocks & 0xf0) | (> <upperPageOffset & 0xf);
    asm {
        lda lMb     // lower blocks offset megabytes
        ldx #$0f    // lower signal for MB offset
        ldy uMb     // upper blocks offset megabytes
        ldz #$00    // upper signal for MB offset
        map
        lda aVal    // lower blocks offset page low
        ldx xVal    // lower blocks to map + lower blocks offset high nibble
        ldy yVal    // upper blocks offset page
        ldz zVal    // upper blocks to map + upper blocks offset page high nibble
        map
        eom
    }
}

// Test more corner case behaviors
// - [DONE] Mapping two blocks to the same memory : [$4000-$5fff] >> [$10000-$12000], [$8000-$9fff] >> [$10000-$12000]
// - Mapping two blocks to overlapping memory : [$4000-$5fff] >> [$10000-$12000], [$6000-$7f00] >> [$11000-$12ff]
// - Mapping a block to the 1MB border : [$4000-$5fff] >> [$ff000-$100fff] or [$ff000-$00fff] ?
// - Mapping a block over zeropage : [$0000-$1fff] >> [$10000-$12000]. Does zp-addressing-mode access the mapped memory? 



