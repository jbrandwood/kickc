// Same animation using a multiplexer
#include <c64.c>
#include <multiplexer.c>
#include <fastmultiply.c>
#include <string.c>
#include <keyboard.c>

// The BOB sprite
align(0x1000) char SPRITE[] = kickasm(resource "smiley.png") {{
    .var pic = LoadPicture("smiley.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

// Sine and Cosine tables
// Angles: $00=0, $80=PI,$100=2*PI
// Sine/Cosine: signed fixed [-$7f,$7f]
align(0x40) signed char SIN[0x140] = kickasm {{
    .for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))
}};

signed char* COS = SIN+0x40; // sin(x) = cos(x+PI/2)

// The BASIC screen
char* const SCREEN = 0x0400;

// The number of BOBs to render
const char NUM_BOBS = 16;

void main() {
    asm { sei }
    init();
    loop();
    exit();
    asm { cli }
}

// Initialize the program
void init() {
    *D011 = VIC_DEN | VIC_RSEL | 3;
    // Initialize the multiplexer
    plexInit(SCREEN);
    // Set the sprite pointers & initial positions
    for(char i: 0..PLEX_COUNT-1) {
        PLEX_PTR[i] = (char)(SPRITE/0x40);
        PLEX_XPOS[i] = 24+i*5;
        PLEX_YPOS[i] = 50+i*8;
    }
    // Enable & initialize sprites
    *SPRITES_ENABLE = 0xff;
    for(char i: 0..7) {
        SPRITES_COLS[i] = GREEN;
    }
    mulf_init();
	// Clear screen
	memset(SCREEN, ' ', 1000);
}

// Exit the program
void exit() {
	// Wait for space release
	while(keyboard_key_pressed(KEY_SPACE)) {}
}

// The main loop
void loop() {
	// Render Rotated BOBs
	char angle = 0;
    while(true) {
        do { } while (*RASTER<0xd8);
        *BORDERCOL = 0xf;
	    signed char r = 30;
        char a = angle;
        for(char i: 0..NUM_BOBS-1) {
            //kickasm {{ .break }}
            *BORDERCOL = 6;
            int x = mulf8s(r, COS[a])*2 + 125*0x100;
            PLEX_XPOS[i] = >x;
            int y = mulf8s(r, SIN[a])*2 + 125*0x100;
            PLEX_YPOS[i] = >y;
            a += 98;
            r += 3;
        }
        *BORDERCOL = 3;
        plexSort();
        angle += 3;
        *BORDERCOL = BLACK;
        // Sort the sprites by y-position
        while((*D011&VIC_RST8)!=0) {}
        // Show the sprites
        for( char i: 0..PLEX_COUNT-1) {
            *BORDERCOL = BLACK;
            char rasterY = plexFreeNextYpos();
            while(*RASTER<rasterY) {}
            (*BORDERCOL)++;
            plexShowSprite();
        }
        *BORDERCOL = BLACK;
	    if(keyboard_key_pressed(KEY_SPACE)) {
	        break;
	    }
    }
}
