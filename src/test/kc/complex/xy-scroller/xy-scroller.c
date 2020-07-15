// A full-screen x/y-scroller
// World space is a 16-bit signed coordinate system [-32768, 32767] x [-32768, 32767]

#include <c64.h>
#include <string.h>

// Display screen #0 (double buffered)
char * const MAIN_SCREEN0 = 0x3800;
// Display screen #1 (double buffered)
char * const MAIN_SCREEN1 = 0x3c00;
// Display charset
char * const MAIN_CHARSET = 0x1000;

// The render 8x8 buffer containing chars to be rendered onto the screen
char RENDER_BUFFER[8*8] =
    "   **   "
    " ****** "
    " ****** "
    "********"
    "********"
    " ****** "
    " ****** "
    "   **   "z;

// The number of sinus values in the table
const unsigned int SINSIZE = 2048;

// Sinus table [-399,399]
signed int SINTAB[SINSIZE] = kickasm(uses SINSIZE) {{
    .fillword SINSIZE, 399*sin(i*2*PI/SINSIZE)
}};

// 140x125 PETSCII art
export __address(0x4000) char PETSCII_ART[140*125] = kickasm(resource "cml.png") {{
    .var petsciiPic = LoadPicture("cml.png")
    .print "width: "+petsciiPic.width + " height: "+petsciiPic.height
    .for (var y=0; y<petsciiPic.height; y++)
        .for (var x=0; x<petsciiPic.width; x++)
            .byte petsciiPic.getPixel(x,y)==0?' ':$a0;
}};

// Current index into the sinus
unsigned int x_sin_idx = 0;
unsigned int y_sin_idx = SINSIZE/4;
// Current x/y-position (the center of the screen)
signed int x_pos;
signed int y_pos;
// The current scroll fine values [0-7] (converted to unsigned)
unsigned char x_pos_fine;
unsigned char y_pos_fine;
// The current scroll coarse values (converted to unsigned)
unsigned int x_pos_coarse;
unsigned int y_pos_coarse;

// The current screen displayed (0/1)
char screen_buffer = 0;

void main() {
    // Stop the kernel IRQ
    sei();
    // Clear screen
    memset(MAIN_SCREEN0, ' ', 1000);
    // Display initial screen
    VICII->MEMORY = toD018(MAIN_SCREEN0, MAIN_CHARSET);
    // Find initial position
    next_position();

    for(;;) {
        //VICII->BORDER_COLOR = RED;

        // The old coarse values x/y-positions
        unsigned int x_pos_coarse_old = x_pos_coarse;
        unsigned int y_pos_coarse_old = y_pos_coarse;
        // Update the position
        next_position();

        // Detect the need for coarse scrolling (moving chars on the entire screen) and the direction of the scroll 
        // Movement is the offset that the screen data should be moved (-40: down, 40: up, -1: right, 1: left, 0: none)
        signed char y_movement = (signed char)(y_pos_coarse_old-y_pos_coarse); // will be -1/0/1
        signed char movement = 0;
        if(y_movement==1) {
            movement = -40;
        } else if(y_movement==-1) {
            movement = 40;
        }
        signed char x_movement = (signed char)(x_pos_coarse_old-x_pos_coarse); // will be -1/0/1
        movement -= x_movement;

        // If coarse scrolling is needed execute it
        if(movement) {
            // Move chars from active screen to hidden screen - while applying any needed movement
            char * screen_active = (screen_buffer?MAIN_SCREEN1:MAIN_SCREEN0) + movement;
            char * screen_hidden = screen_buffer?MAIN_SCREEN0:MAIN_SCREEN1;
            screencpy(screen_hidden, screen_active);

            // Update any new row if needed
            char* petscii;
            char* scrn;
            if(y_movement) {
                if(y_movement==-1) {
                    // Update Bottom row 
                    petscii = petscii_ptr(x_pos_coarse-20, y_pos_coarse+12);
                    scrn = screen_hidden+24*40; 
                } else { // y_movement==1
                    // Update Top row 
                    petscii = petscii_ptr(x_pos_coarse-20, y_pos_coarse-12);
                    scrn = screen_hidden; 
                }
                for(char i=0;i<40;i++)
                    scrn[i] = petscii[i];
            }
            // Update any new column if needed
            if(x_movement) {
                if(x_movement==-1) {
                    // Update Right column
                    petscii = petscii_ptr(x_pos_coarse+19, y_pos_coarse-12);
                    scrn = screen_hidden+39; 
                } else { // x_movement==1
                    // Update Left column
                    petscii = petscii_ptr(x_pos_coarse-20, y_pos_coarse-12);
                    scrn = screen_hidden; 
                }
                for(char i=0;i<25;i++) {
                    *scrn = *petscii;
                    scrn += 40;
                    petscii += 140;
                }
            }

            // Change current screen
            screen_buffer ^=1;

        }
        //VICII->BORDER_COLOR = BLACK;

        // Update the display - wait for the raster
        while(VICII->RASTER!=0xfe) ;
        while(VICII->RASTER!=0xff) ;
        VICII->BORDER_COLOR = WHITE;
        // Y-scroll fine
        VICII->CONTROL1 = VICII->CONTROL1 & 0xf0 | (7-y_pos_fine);
        // X-scroll fine
        VICII->CONTROL2 = VICII->CONTROL2 & 0xf0 | (7-x_pos_fine);
        // Display current screen
        if(screen_buffer) {
            VICII->MEMORY = toD018(MAIN_SCREEN1, MAIN_CHARSET);
        } else {
            VICII->MEMORY = toD018(MAIN_SCREEN0, MAIN_CHARSET);
        }
        VICII->BORDER_COLOR = BLACK;

    }

}

// Get a pointer to a specific x,y-position in the PETSCII art
char* petscii_ptr(unsigned int row_x, unsigned int row_y) {
    return PETSCII_ART + row_y * 140 + row_x;
}

// Copy an entire screen (40x25 = 1000 chars)
// - dst - destination
// - src - source
void screencpy( char* dst, char* src) {
    char* src_250 = src+250;
    char* dst_250 = dst+250;
    char* src_500 = src+500;
    char* dst_500 = dst+500;
    char* src_750 = src+750;
    char* dst_750 = dst+750;
    for( char i=0;i<250;i++) {
        dst[i] = src[i];
        dst_250[i] = src_250[i];
        dst_500[i] = src_500[i];
        dst_750[i] = src_750[i];
    }
}

inline void sei() {
    asm { sei }
}

inline void breakpoint() {
    kickasm {{ .break }}
}

// Update the x_pos, y_pos variables to reflect the next position on the curve 
// The position represents the center of the screen
void next_position() {
        // Move forward along the curve
        x_sin_idx++; if(x_sin_idx>=SINSIZE) x_sin_idx-=SINSIZE;
        y_sin_idx++; if(y_sin_idx>=SINSIZE) y_sin_idx-=SINSIZE;
        // Find the next point
        x_pos = SINTAB[x_sin_idx];
        y_pos = SINTAB[y_sin_idx];
        // Find the unsigned fine/coarse scroll values
        unsigned int x_pos_u = (unsigned int)x_pos + 400 + 20*8;
        x_pos_fine = (unsigned char)x_pos_u & 7;
        x_pos_coarse = x_pos_u/8;
        unsigned int y_pos_u = (unsigned int)y_pos + 400 + 12*8;
        y_pos_fine = (unsigned char)y_pos_u & 7;
        y_pos_coarse = y_pos_u/8;  
}