// A simple usage of the flexible sprite multiplexer routine
#include <c64.h>
#include <multiplexer.h>

// Location of screen & sprites
char* SCREEN = $400;

char __align(0x100) YSIN[0x100] = kickasm {{
    .var min = 50
    .var max = 250-21
    .var ampl = max-min;
    .for(var i=0;i<256;i++)
        .byte round(min+(ampl/2)+(ampl/2)*sin(toRadians(360*i/256)))
}};

__address(0x2000) char SPRITE[] = kickasm(resource "balloon.png") {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
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
        PLEX_PTR[sx] = (char)(SPRITE/$40);
        PLEX_XPOS[sx] = xp;
        xp += 9;
    }
    // Enable & initialize sprites
    VICII->SPRITES_ENABLE = $ff;
    for(char ss: 0..7) {
        SPRITES_COLOR[ss] = GREEN;
    }
}

// The raster loop
void loop() {
    // The current index into the y-sine
    char sin_idx = 0;
    while(true) {
        while(VICII->RASTER!=$ff) {}
        // Assign sine positions
        (VICII->BORDER_COLOR)++;
        char y_idx = sin_idx;
        for(char sy: 0..PLEX_COUNT-1) {
            PLEX_YPOS[sy] = YSIN[y_idx];
            y_idx += 8;
        }
        sin_idx +=1;
        // Sort the sprites by y-position
        (VICII->BORDER_COLOR)++;
        plexSort();
        VICII->BORDER_COLOR = BLACK;
        while((*D011&VIC_RST8)!=0) {}
        // Show the sprites
        for( char ss: 0..PLEX_COUNT-1) {
            VICII->BORDER_COLOR = BLACK;
            char rasterY = plexFreeNextYpos();
            while(VICII->RASTER<rasterY) {}
            (VICII->BORDER_COLOR)++;
            plexShowSprite();
        }
        VICII->BORDER_COLOR = BLACK;
    }
}