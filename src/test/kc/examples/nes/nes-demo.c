// A minimal NES demo
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 
#pragma target(nes)
#include <nes.h>
#include <string.h>

// RESET Called when the NES is reset, including when it is turned on.
void main() {
    asm { 
        cld 
        ldx #$ff            
        txs        
    }

    // Initialize the video & audio
    disableVideoOutput();
    disableAudioOutput();
    // Note: When the system is first turned on or reset, the PPU may not be in a usable state right
    // away. You should wait at least 30,000 (thirty thousand) CPU cycles for the PPU to initialize, 
    // which may be accomplished by waiting for 2 (two) vertical blank intervals.
    clearVBlankFlag();
    waitForVBlank();
    // Clear RAM - since it has all variables and the stack it is necesary to do it inline
    char i=0;
    do {
        (MEMORY+0x000)[i] = 0; 
        (MEMORY+0x100)[i] = 0; 
        (MEMORY+0x200)[i] = 0; 
        (MEMORY+0x300)[i] = 0; 
        (MEMORY+0x400)[i] = 0; 
        (MEMORY+0x500)[i] = 0; 
        (MEMORY+0x600)[i] = 0; 
        (MEMORY+0x700)[i] = 0; 
    } while (++i);
    waitForVBlank();
    // Now the PPU is ready.

    initPaletteData();
    initSpriteData();
    enableVideoOutput();

    // Infinite loop
    while(1) {
    }

}

// NMI Called when the PPU refreshes the screen (also known as the V-Blank period)
interrupt(hardware_stack) void vblank() {

    // Refresh DRAM-stored sprite data before it decays.
    // Set OAM start address to sprite#0
    PPU->OAMADDR = 0;
    // Set the high byte (02) of the RAM address and start the DMA transfer to OAM memory
    APU->OAMDMA = >OAM_BUFFER; 

    // Freeze the button positions.
    APU->JOY1 = 1;
    APU->JOY1 = 0;
    // Controllers for first and second player are now latched and will not change

   // Read button A on controller 1
    if(APU->JOY1&0b00000001) {
        moveLuigiRight();
    }

   // Read button B on controller 1
    if(APU->JOY1&0b00000001) {
        moveLuigiLeft();
    }

}

// Copy palette values to PPU
void initPaletteData() {
    // Reset the high/low latch to "high"
    asm { lda PPU_PPUSTATUS }
    // Write the high byte of PPU Palette address
    PPU->PPUADDR = >PPU_PALETTE;
    // Write the low byte of PPU Palette address
    PPU->PPUADDR = <PPU_PALETTE;
    // Write to PPU
    for(char i=0;i<sizeof(PALETTE);i++)
        PPU->PPUDATA = PALETTE[i];
}

char PALETTE[0x20] = {
    // Background palettes
    0x0f, 0x31, 0x32, 0x33,
    0x0f, 0x35, 0x36, 0x37,
    0x0f, 0x39, 0x3a, 0x3b,
    0x0f, 0x3d, 0x3e, 0x0f,
    // Sprite palettes (selected by the attribute bits 0-1 of the sprites)
    0x0f, 0x1c, 0x15, 0x14,
    0x0f, 0x02, 0x38, 0x3c,
    0x0f, 0x30, 0x37, 0x1a,  // Luigi-like colors
    0x0f, 0x0f, 0x0f, 0x0f   // All black
};    

// Sprite Object Attribute Memory Structure
struct ObjectAttribute {
    char y;
    char tile;
    char attributes;
    char x;
};

// OAM (Object Attribute Memory) Buffer
// Will be transfered to the PPU via DMA
struct ObjectAttribute * const OAM_BUFFER = 0x0200;

// move the Luigi sprites right
void moveLuigiRight() {
    OAM_BUFFER[0].x++;
    OAM_BUFFER[1].x++;
    OAM_BUFFER[2].x++;
    OAM_BUFFER[3].x++;
}

// move the Luigi sprites left
void moveLuigiLeft() {
    OAM_BUFFER[0].x--;
    OAM_BUFFER[1].x--;
    OAM_BUFFER[2].x--;
    OAM_BUFFER[3].x--;
}

// Initialize OAM (Object Attribute Memory) Buffer 
void initSpriteData() {
    char i=0;
    do {
        ((char*)OAM_BUFFER)[i] = ((char*)SPRITES)[i];
    } while (++i!=sizeof(SPRITES));
}

// Small Luigi Sprite Data
struct ObjectAttribute SPRITES[] = {
//     Y ,  TILE,  ATTR      ,  X
    { 128,  0x36,  0b00000010,  128 },		// Sprite 0
    { 128,  0x37,  0b00000010,  136 },		// Sprite 1
    { 136,  0x38,  0b00000010,  128 },		// Sprite 2
    { 136,  0x39,  0b00000010,  136 }		// Sprite 3
};

// Tiles
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
