// lazyNES lazyhello demo
// Main file 

// Ported to KickC 2020 by Jesper Gravgaard 
// Original Source VBCC aplha 2 http://www.ibaug.de/vbcc/vbcc6502_2.zip

#pragma target(nes)
#include <nes.h>
#include <string.h>
#include "lazynes.c"
#include "lazyhello.c"

// RESET Called when the NES is reset, including when it is turned on.
void main() {
    // Initialize NES after RESET
    initNES();
    // Clear the name table
    ppuDataFill(PPU_NAME_TABLE_0, 0, 0x3c0);
    // Fill the PPU attribute table
    ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40);    
    // Enable screen rendering and vblank
    enableVideoOutput();
    // Execute main code
    lnMain();
    // Infinite loop
    while(1) ;
}

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
interrupt(hardware_stack) void vblank() {
    // DMA transfer the entire sprite buffer to the PPU
    ppuSpriteBufferDmaTransfer(SPRITE_BUFFER);
    // Set scroll
    PPU->PPUSCROLL = 0;
    PPU->PPUSCROLL = 0;
}

// Data (in PRG ROM)
#pragma data_seg(Data)
 
// Tile Set (in CHR ROM)
#pragma data_seg(Tiles)
export char TILES[] = kickasm(resource "example.chr") {{
	.import binary "example.chr"
}};

// Sprite Buffer (in GAME RAM)
// Will be transferred to the PPU via DMA during vblank
#pragma data_seg(GameRam)
struct SpriteData align(0x100) SPRITE_BUFFER[0x40];

// Interrupt Vectors (in PRG ROM)
#pragma data_seg(Vectors)
export void()* const VECTORS[] = { 
    // NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
    &vblank, 
    // RESET Called when the NES is reset, including when it is turned on.
    &main, 
    // IRQ Called when a BRK instruction is executed.
    0 
};
