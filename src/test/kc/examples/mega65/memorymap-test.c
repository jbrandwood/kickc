// Test the MAP instruction for remapping memory
#pragma target(mega65)
#pragma emulator("/Users/jespergravgaard/c64/mega65/xemu-hernandp/build/bin/xmega65.native -prg")
#include <mega65.h>

void main() {
    // Remap block at $4000 to point to $10000
    // offset = $10000-$4000 = $c000
    asm {
        lda #$c0 // lower blocks offset page
        ldx #$40 // lower blocks to map + lower blocks offset page
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

}


// Remap one of the 8 8K memory blocks of the MEGA65 to point to somewhere else in the 256MB memory space.
// After the remapping the CPU will be actualy be accessing the remapped memory whenever it uses instructions accessing the remapped block.
// blockAddress: The address of the 8K memory block to remap. The block addresses are: $0000, $2000, $4000, ...
// newAddress: The address in 256MB memory that the block should point to. The address must be 256b page aligned: $00000000, $00000100, $00000200, ...
void memoryBlockRemap(unsigned int blockAddress, unsigned long newAddress) {


}

