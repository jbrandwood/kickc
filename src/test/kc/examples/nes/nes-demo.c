// A minimal NES demo
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
#pragma target(nes)
#include <nes.h>
#include <string.h>

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
    // Show floor
    for(char x=0;x<32;x+=2)
        ppuDataPutTile(PPU_NAME_TABLE_0+20*32+x, FLOOR);
    // Show flag
    ppuDataPutTile(PPU_NAME_TABLE_0+18*32+28, FLAG);
    // Initialize Sprite Buffer with the SPRITE data
    memcpy(SPRITE_BUFFER, SPRITES, sizeof(SPRITES));

    // Enable screen rendering and vblank
    enableVideoOutput();
    // Infinite loop
    while(1) {
    }
}

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
__interrupt void vblank() {

   // Read controller 1
    char joy = readJoy1();
    if(joy&JOY_DOWN) {
        SPRITE_BUFFER[0].y++;
        SPRITE_BUFFER[1].y++;
        SPRITE_BUFFER[2].y++;
        SPRITE_BUFFER[3].y++;
    }
    if(joy&JOY_UP) {
        SPRITE_BUFFER[0].y--;
        SPRITE_BUFFER[1].y--;
        SPRITE_BUFFER[2].y--;
        SPRITE_BUFFER[3].y--;    
    }
    if(joy&JOY_LEFT) {
        SPRITE_BUFFER[0].x--;
        SPRITE_BUFFER[1].x--;
        SPRITE_BUFFER[2].x--;
        SPRITE_BUFFER[3].x--;    
    }
    if(joy&JOY_RIGHT) {
        SPRITE_BUFFER[0].x++;
        SPRITE_BUFFER[1].x++;
        SPRITE_BUFFER[2].x++;
        SPRITE_BUFFER[3].x++;    
    }

    // DMA transfer the entire sprite buffer to the PPU
    ppuSpriteBufferDmaTransfer(SPRITE_BUFFER);

    // Set scroll
    PPU->PPUSCROLL = 0;
    PPU->PPUSCROLL = -8;

}

// Data (in PRG ROM)
#pragma data_seg(Data)

// Flag tile
char FLAG[] = { 0x54, 0x55, 0x56, 0x57};
// Floor tile
char FLOOR[] = { 0x85, 0x85, 0x86, 0x86};

// Sprite Data
struct SpriteData SPRITES[] = {
    // Small Luigi
    // Y ,  TILE,  ATTR      ,  X
    { 150,  0x36,  0b00000010,  12 },		// Sprite 0
    { 150,  0x37,  0b00000010,  20 },		// Sprite 1
    { 158,  0x38,  0b00000010,  12 },		// Sprite 2
    { 158,  0x39,  0b00000010,  20 },		// Sprite 3
    // Small Goomba 
    // Y ,  TILE,  ATTR      ,  X
    { 150,  0x70,  0b00000000,  72 },		// Sprite 0
    { 150,  0x71,  0b00000000,  80 },		// Sprite 1
    { 158,  0x72,  0b00000001,  72 },		// Sprite 2
    { 158,  0x73,  0b00000001,  80 }		// Sprite 3
};

// Color Palette
char PALETTE[0x20] = {
    // Background palettes
    0x11, 0x2d, 0x08, 0x18,
    0x11, 0x06, 0x15, 0x36,
    0x11, 0x39, 0x4a, 0x5b,
    0x0f, 0x3d, 0x4e, 0x5f,
    // Sprite palettes (selected by the attribute bits 0-1 of the sprites)
    0x11, 0x0f, 0x30, 0x08,   // Goomba upper colors
    0x11, 0x0f, 0x18, 0x08,   // Goomba lower colors
    0x11, 0x30, 0x37, 0x1a,  // Luigi-like colors
    0x0f, 0x0f, 0x0f, 0x0f   // All black
};    

// Tile Set (in CHR ROM)
#pragma data_seg(Tiles)
__export char TILES[] = kickasm(resource "smb1_chr.bin") {{
	.import binary "smb1_chr.bin"
}};

// Sprite Buffer (in GAME RAM)
// Will be transferred to the PPU via DMA during vblank
#pragma data_seg(GameRam)
struct SpriteData __align(0x100) SPRITE_BUFFER[0x40];

// Interrupt Vectors (in PRG ROM)
#pragma data_seg(Vectors)
__export void (*VECTORS[])() = {
    // NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
    &vblank, 
    // RESET Called when the NES is reset, including when it is turned on.
    &main, 
    // IRQ Called when a BRK instruction is executed.
    0 
};
