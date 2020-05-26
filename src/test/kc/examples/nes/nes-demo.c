// A minimal NES demo
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
#pragma target(nes)
#include <nes.h>
#include <string.h>

// Sprite OAM Buffer
// Will be transfered to the PPU via DMA during vblank
struct SpriteData * const OAM_BUFFER = 0x0200;

// RESET Called when the NES is reset, including when it is turned on.
void main() {
    // Initialize NES after RESET
    initNES();
    // Transfer the palette
    ppuDataTransfer(PPU_PALETTE, PALETTE, sizeof(PALETTE));
    // Clear the name table
    ppuDataFill(PPU_NAME_TABLE_0, 0xfc, 0x3c0);
    // Fill the PPU attribute table
    ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40);
    // Show the entire tile set
    //char ch=0;
    //for(char y=0;y!=16;y++) {
    //    ppuDataPrepare(PPU_NAME_TABLE_0+32*4+4+(unsigned int)y*32);
    //    for(char x=0;x!=16;x++)
    //        ppuDataPut(ch++);
    //}
    // Show floor
    for(char x=0;x<32;x+=2)
        ppuDataPutTile(PPU_NAME_TABLE_0+20*32+x, FLOOR);
    // Show flag
    ppuDataPutTile(PPU_NAME_TABLE_0+18*32+28, FLAG);
    // Initialize Sprite OAM Buffer with the SPRITE data
    for(char i=0;i<sizeof(SPRITES); i++)
        ((char*)OAM_BUFFER)[i] = ((char*)SPRITES)[i];
    // Set initial scroll
    PPU->PPUSCROLL = 0;
    PPU->PPUSCROLL = -8;
    // Enable screen rendering and vblank
    enableVideoOutput();
    // Infinite loop
    while(1) {
    }
}

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
interrupt(hardware_stack) void vblank() {

    // DMA transfer the entire sprite buffer to the PPU
    ppuSpriteBufferDmaTransfer(OAM_BUFFER);

    // Latch the controller buttons
    APU->JOY1 = 1;
    APU->JOY1 = 0;
    // Controllers for first and second player are now latched and will not change

   // Read button A on controller 1
    if(APU->JOY1&0b00000001) {
        // move the Luigi sprites right
        OAM_BUFFER[0].y++;
        OAM_BUFFER[1].y++;
        OAM_BUFFER[2].y++;
        OAM_BUFFER[3].y++;
    }

   // Read button B on controller 1
    if(APU->JOY1&0b00000001) {
        // move the Luigi sprites left
        OAM_BUFFER[0].y--;
        OAM_BUFFER[1].y--;
        OAM_BUFFER[2].y--;
        OAM_BUFFER[3].y--;    
    }

}

// Flag tile
char FLAG[] = { 0x54, 0x55, 0x56, 0x57};
// Floor tile
char FLOOR[] = { 0x85, 0x85, 0x86, 0x86};

// Small Luigi Sprite Data
struct SpriteData SPRITES[] = {
//     Y ,  TILE,  ATTR      ,  X
    { 128,  0x36,  0b00000010,  128 },		// Sprite 0
    { 128,  0x37,  0b00000010,  136 },		// Sprite 1
    { 136,  0x38,  0b00000010,  128 },		// Sprite 2
    { 136,  0x39,  0b00000010,  136 }		// Sprite 3
};

// Color Palette
char PALETTE[0x20] = {
    // Background palettes
    0x0f, 0x13, 0x23, 0x33,
    0x0f, 0x06, 0x15, 0x36,
    0x0f, 0x39, 0x4a, 0x5b,
    0x0f, 0x3d, 0x4e, 0x5f,
    // Sprite palettes (selected by the attribute bits 0-1 of the sprites)
    0x0f, 0x1c, 0x15, 0x14,
    0x0f, 0x02, 0x38, 0x3c,
    0x0f, 0x30, 0x37, 0x1a,  // Luigi-like colors
    0x0f, 0x0f, 0x0f, 0x0f   // All black
};    

// Tile Set
#pragma data_seg(Tiles)
export char TILES[] = kickasm(resource "smb1_chr.bin") {{
	.import binary "smb1_chr.bin"
}};

// Interrupt Vectors
#pragma data_seg(Vectors)
export void()* const VECTORS[] = { 
    // NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
    &vblank, 
    // RESET Called when the NES is reset, including when it is turned on.
    &main, 
    // IRQ Called when a BRK instruction is executed.
    0 
};
