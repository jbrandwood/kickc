// Test the MAP instruction for remapping memory
#pragma target(mega65)
#pragma emulator("/Users/jespergravgaard/c64/mega65/xemu-hernandp/build/bin/xmega65.native -prg")
#include <mega65.h>

void main() {
    /*
    // Remap block at $4000 to point to $10000
    // offset = $10000-$4000 = $c000
    asm {
        lda #$c0 // lower blocks offset page
        ldx #$40 // lower blocks to map + lower blocks offset 
        ldy #0
        ldz #0
        map
        eom
    }
    // Put data into $4000
    asm {
        lda #$55
        sta $4000
    }
     */


    char * block1 = 0x4000;
    char * block2 = 0x8000;
    memoryBlockRemap((unsigned char)>block1, 0x100);
    memoryBlockRemap((unsigned char)>block2, 0x120);

    // TODO: The mapper can only map the lower 32K to one memory address and the upper 32K to another
    // TODO: The mapper always remaps both - so it cannot be separated into two different calls (without some memory)!

    block1[0] = 0x55;
    block1[1] = 0xaa;
    block2[0] = 0x55;
    block2[1] = 0xaa;
    //block2[1] = 0xaa;
    //block2[2] = block1[1];




}


// Remap one of the eight 8K memory blocks in the 64K address space of the 6502 to point somewhere else in the first 1MB memory space of the MEGA65.
// After the remapping the CPU will access the mapped memory whenever it uses instructions that access the mapped block.
// blockPage: Page address of the 8K memory block to remap (ie. the block that is remapped is $100 * the passed page address.) 
// Legal block page addresses are: $00: block $0000-$1fff, $20: block $2000-$3fff, ..., $e0: block $e000-$ffff 
// memoryPage: Page address of the memory that the block should point to in the 1MB memory space of the MEGA65. 
// Ie. the memory that will be pointed to is $100 * the passed page address. Only the lower 12bits of the passed value is used.
void memoryBlockRemap(unsigned char blockPage, unsigned int memoryPage) {
    // Which block is being remapped? (0-7)
    char block = blockPage / $20;
    // Find the page offset (the number of pages to offset the block)
    unsigned int pageOffset = memoryPage-blockPage;
    if(block&4) {
        // High block (4-7)
        char * yVal = 0xfe;
        char * zVal = 0xff;
        *yVal = <pageOffset;
        *zVal = 1<<(block) | (>pageOffset & 0xf);
        asm {
            lda #0      // lower blocks offset page low
            ldx #0      // lower blocks to map + lower blocks offset page high nibble
            ldy yVal    // upper blocks offset page
            ldz zVal    // upper blocks to map + upper blocks offset page high nibble
            map
            eom
        }
    } else {
        // Low block (0-3)
        char * aVal = 0xfe;
        char * xVal = 0xff;
        *aVal = <pageOffset;
        *xVal = 1<<(4|block) | (>pageOffset & 0xf);
        asm {
            lda aVal    // lower blocks offset page low
            ldx xVal    // lower blocks to map + lower blocks offset high nibble
            ldy #0      // upper blocks offset page
            ldz #0      // upper blocks to map + upper blocks offset page high nibble
            map
            eom
        }

    }

}

// Test corner case behaviors
// - Mapping two blocks to the same memory : [$4000-$5fff] >> [$10000-$12000], [$6000-$7fff] >> [$10000-$12000]
// - Mapping two blocks to overlapping memory : [$4000-$5fff] >> [$10000-$12000], [$6000-$7f00] >> [$11000-$12ff]
// - Mapping a block to the 1MB border : [$4000-$5fff] >> [$ff000-$100fff] or [$ff000-$00fff] ?
// - Mapping a block over zeropage : [$0000-$1fff] >> [$10000-$12000]. Does zp-addressing-mode access the mapped memory? 


// Add memory block remapping to the full 256MB memory

