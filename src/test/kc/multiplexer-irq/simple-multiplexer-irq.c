// A simple usage of the flexible sprite multiplexer routine
#include <c64.h>
#include <multiplexer.h>
// Location of screen & sprites
char* SCREEN = 0x0400;

char __align(0x40) SPRITE[0x40] = kickasm(resource "balloon.png") {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

char __align(0x100) YSIN[0x100] = kickasm {{
    .fill $100, round(139.5+89.5*sin(toRadians(360*i/256)))
}};

void main() {
    asm { sei }
    init();
    loop();
}

// Initialize the program
void init() {
    *D011 = VIC_DEN | VIC_RSEL | 3;
    // Initialize the multiplexer
    plexInit(SCREEN);
    // Set the x-positions & pointers
    unsigned int xp = 32;
    for(char sx: 0..PLEX_COUNT-1) {
        PLEX_PTR[sx] = (char)(SPRITE/0x40);
        PLEX_XPOS[sx] = xp;
        xp += 9;
    }
    // Enable & initialize sprites
    *SPRITES_ENABLE = 0xff;
    for(char ss: 0..7) {
        SPRITES_COLOR[ss] = GREEN;
    }
    // enable the interrupt
    asm { sei }
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    *IRQ_ENABLE = IRQ_RASTER;
    *IRQ_STATUS = IRQ_RASTER;
    *KERNEL_IRQ = &plex_irq;
    *VIC_CONTROL &= 0x7f;
    *RASTER = 0x0;
    asm { cli }
}

volatile bool framedone = true;

__interrupt void plex_irq() {
    asm { sei }
    *BORDER_COLOR = WHITE;
    char rasterY;
    do {
        plexShowSprite();
        rasterY = plexFreeNextYpos();
    } while (plex_show_idx < PLEX_COUNT && rasterY < *RASTER+2);
    *IRQ_STATUS = IRQ_RASTER;
    if (plex_show_idx<PLEX_COUNT) {
        *RASTER = rasterY;
    } else {
        *RASTER = 0x0;
        framedone = true;
    }
    *BORDER_COLOR = 0;
    asm { cli }
}

// The raster loop
void loop() {
// The current index into the y-sine
    char sin_idx = 0;
    while(true) {
        while(!framedone) { }
        *BORDER_COLOR = RED;
        // Assign sine positions
        char y_idx = sin_idx;
        for(char sy: 0..PLEX_COUNT-1) {
            PLEX_YPOS[sy] = YSIN[y_idx];
            y_idx += 8;
        }
        sin_idx +=1;
        // Sort the sprites by y-position
        (*BORDER_COLOR)++;
        plexSort();
        *BORDER_COLOR = GREEN;
        framedone = false;

    }
}