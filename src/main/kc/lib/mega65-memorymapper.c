// MEGA65 Memory Mapper allows the 6502 CPU to access up to 256MB of memory by remapping where the eight 8K blocks point in real memory.
// The memory mapping is configured through the new MAP instruction of the MOS 4510.
// https://mega65.org/
// https://mega.scryptos.com/sharefolder-link/MEGA/MEGA65+filehost/Docs/MEGA65-Book_draft.pdf
// https://github.com/MEGA65/mega65-core/blob/master/src/vhdl/gs4510.vhdl
// http://www.zimmers.net/cbmpics/cbm/c65/c65manual.txt
// http://anyplatform.net/media/guides/cpus/65xx%20Processor%20Data.txt


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
    // lower blocks offset page low
    char aVal = BYTE0(lowerPageOffset);
    // lower blocks to map + lower blocks offset high nibble
    char xVal = (remapBlocks << 4)   | (BYTE1(lowerPageOffset) & 0xf);
    // upper blocks offset page
    char yVal = BYTE0(upperPageOffset);
    // upper blocks to map + upper blocks offset page high nibble
    char zVal = (remapBlocks & 0xf0) | (BYTE1(upperPageOffset) & 0xf);
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
    // lower blocks offset megabytes
    char lMb = BYTE1((unsigned int)(lowerPageOffset>>4));
    // upper blocks offset megabytes
    char uMb = BYTE1((unsigned int)(upperPageOffset>>4));
    // lower blocks offset page low
    char aVal = BYTE0(lowerPageOffset);
    // lower blocks to map + lower blocks offset high nibble
    char xVal = (remapBlocks << 4)   | (BYTE1(lowerPageOffset) & 0xf);
    // upper blocks offset page
    char yVal = BYTE0(upperPageOffset);
    // upper blocks to map + upper blocks offset page high nibble
    char zVal = (remapBlocks & 0xf0) | (BYTE1(upperPageOffset) & 0xf);
    asm {
        lda lMb     // lower blocks offset megabytes
        ldx #$0f    // lower signal for MB offset
        ldy uMb     // upper blocks offset megabytes
        ldz #$0f    // upper signal for MB offset
        map
        lda aVal    // lower blocks offset page low
        ldx xVal    // lower blocks to map + lower blocks offset high nibble
        ldy yVal    // upper blocks offset page
        ldz zVal    // upper blocks to map + upper blocks offset page high nibble
        map
        eom
    }
}
