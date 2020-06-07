// NES DXYCP using sprites
#pragma target(nes)
#include <nes.h>
#include <string.h>

// RESET Called when the NES is reset, including when it is turned on.
void main() {
    // Initialize NES after RESET
    initNES();
    // Transfer the palette
    ppuDataTransfer(PPU_PALETTE, PALETTE, sizeof(PALETTE));
    // Fill the PPU attribute table
    ppuDataFill(PPU_NAME_TABLE_0, '*', 32*30);
    ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40);
    // Initialize Sprite Buffer with the SPRITE data
    for(char s=0;s<0x40;s++) {        
        SPRITE_BUFFER[s] = { 0, MESSAGE[s], 0b00000010, 0 };
    }
    // Enable screen rendering and vblank
    enableVideoOutput();
    // Infinite loop
    while(1) {
    }
}

// Index into the Y sine
volatile char y_sin_idx = 0;
// Index into the X sine
volatile char x_sin_idx = 73;

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
interrupt(hardware_stack) void vblank() {
    // Set scroll
    PPU->PPUSCROLL = 0;
    PPU->PPUSCROLL = 0;    
    // DMA transfer the entire sprite buffer to the PPU
    ppuSpriteBufferDmaTransfer(SPRITE_BUFFER);
    // Update sprite positions
    char y_idx = y_sin_idx++;    
    char x_idx = x_sin_idx++;    
    for(char s=0;s<0x40;s++) {
        SPRITE_BUFFER[s].y = SINTABLE[y_idx];
        SPRITE_BUFFER[s].x = SINTABLE[x_idx]+8;
        y_idx += 4;
        x_idx -= 7;
    }
}

// Data (in PRG ROM)
#pragma data_seg(Data)

// The DXYCP message  0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
char MESSAGE[0x40] = "rex-of-camelot-presents-a-dxycp-on-nintendo-entertainment-system"z;

// Color Palette
char PALETTE[0x20] = {
    // Background palettes
    0x01, 0x21, 0x0f, 0x30, // C64 colors
    0x01, 0x21, 0x0f, 0x30, // C64 colors
    0x01, 0x21, 0x0f, 0x30, // C64 colors
    0x01, 0x21, 0x0f, 0x30, // C64 colors
    // Sprite palettes (selected by the attribute bits 0-1 of the sprites)
    0x01, 0x0f, 0x30, 0x08,   // Goomba upper colors
    0x01, 0x0f, 0x18, 0x08,   // Goomba lower colors
    0x01, 0x30, 0x37, 0x1a,  // Luigi-like colors
    0x0f, 0x0f, 0x0f, 0x0f   // All black
}; 

// Sinus Table (0-239)
const char SINTABLE[0x100] = kickasm {{
    .fill $100, round(115.5+107.5*sin(2*PI*i/256))
}};

// Tile Set (in CHR ROM) - A C64 charset from http://www.zimmers.net/anonftp/pub/cbm/firmware/computers/c64/
#pragma data_seg(Tiles)
export char TILES[] = kickasm(resource "characters.901225-01.bin") {{
    .var filechargen = LoadBinary("characters.901225-01.bin")
     .for(var c=0; c<256; c++) {
        // Plane 0
        .fill 8, filechargen.get(c*8+i)
        // Plane 1
        .fill 8, 0
    }
}};

// Sprite Buffer (in GAME RAM)
// Will be transferred to the PPU via DMA during vblank
#pragma data_seg(GameRam)
struct SpriteData align(0x100) SPRITE_BUFFER[0x100];

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