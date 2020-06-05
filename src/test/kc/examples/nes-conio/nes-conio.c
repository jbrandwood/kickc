// NES conio printing
#pragma target(nes)
#include <nes.h>
#include <conio.h>

// RESET Called when the NES is reset, including when it is turned on.
void main() {
    // Initialize NES after RESET
    initNES();
    // Transfer the palette
    ppuDataTransfer(PPU_PALETTE, PALETTE, sizeof(PALETTE));
    // Fill the PPU attribute table
    ppuDataFill(PPU_ATTRIBUTE_TABLE_0, 0, 0x40);
    ppuDataFill(PPU_ATTRIBUTE_TABLE_1, 0, 0x40);
    // Print a string
    clrscr();
    cputs("hello world!\ni am nes\n look at me \n\n");

    x_scroll = 0;
    y_scroll = -8;


    // Enable screen rendering and vblank
    enableVideoOutput();
    // Infinite loop
    while(1) {
    }
}

volatile char x_scroll;
volatile char y_scroll;

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
interrupt(hardware_stack) void vblank() {
   // Read controller 1
    char joy = readJoy1();
    if(joy&JOY_DOWN) {
        if(++y_scroll==240)
            y_scroll=0;
    }
    if(joy&JOY_UP) {
        if(--y_scroll==255)
            y_scroll=239;
    }
    if(joy&JOY_LEFT) {
        x_scroll++;
    }
    if(joy&JOY_RIGHT) {
        x_scroll--;
    }

    PPU->PPUSCROLL = x_scroll;
    PPU->PPUSCROLL = y_scroll;
}

// Data (in PRG ROM)
#pragma data_seg(Data)

char MESSAGE[] = "hello world!";

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
