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
// Index into the small X sine
volatile char x_sin_idx_2 = 82;

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
__interrupt void vblank() {
    // Set scroll
    PPU->PPUSCROLL = 0;
    PPU->PPUSCROLL = 0;    
    // DMA transfer the entire sprite buffer to the PPU
    ppuSpriteBufferDmaTransfer(SPRITE_BUFFER);

    // Read controller 1
    char joy = readJoy1();
    // If anything pressed - pause
    if(joy) 
        return;

    // Update sprite positions
    char y_idx = y_sin_idx++;
    x_sin_idx = (x_sin_idx==238) ? 0 : x_sin_idx+1;
    char x_idx = x_sin_idx;
    x_sin_idx_2 = (x_sin_idx_2==88) ? 0 : x_sin_idx_2+1;
    char x_idx_2 = x_sin_idx_2;
    for(char s=0;s<0x40;s++) {
        SPRITE_BUFFER[s].y = SINTABLE_240[y_idx];
        y_idx -= 4;
        SPRITE_BUFFER[s].x = SINTABLE_184[x_idx] + SINTABLE_64[x_idx_2];
        x_idx = (x_idx<3) ? x_idx+236 : x_idx-3;
        x_idx_2 = (x_idx_2>=86) ? x_idx_2-86 : x_idx_2+3 ;
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

// Sine Table (0-239)
const char SINTABLE_240[0x100] = kickasm {{
    .fill $100, round(115.5+107.5*sin(2*PI*i/256))
}};

// Sine Table (0-63)
const char SINTABLE_64[89] = kickasm {{
    .fill 89, round(52.5+52.5*sin(2*PI*i/89))
}};

// Sine Table (0-183)
const char SINTABLE_184[239] = kickasm {{
    .fill 239, round(71.5+71.5*sin(2*PI*i/239))
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