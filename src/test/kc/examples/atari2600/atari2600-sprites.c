// Minimal Atari 2600 VCS Program using Sprites
// Source: https://atariage.com/forums/blogs/entry/11109-step-1-generate-a-stable-display/
#pragma target(atari2600)
#include <atari2600.h>
#pragma var_model(mem)

// Data
#pragma data_seg(Data)
const char SINTABLE_160[0x100] = kickasm {{
    .fill $100, 5+round(74.5+74.5*sin(2*PI*i/256))
}};

char SPRITE_C[] = { 
    0,
    0b00011000,
    0b00011000,
    0b00011000,
    0b00011000,
    0b00111100,
    0b00111100,
    0b00111100,
    0b00111100,
    0b01100110,
    0b01100110,
    0b01100110,
    0b01100110,
    0b11000000,
    0b11000000,
    0b11000000,
    0b11000000,
    0b11000000,
    0b11000000,
    0b11000000,
    0b11000000,
    0b01100110,
    0b01100110,
    0b01100110,
    0b01100110,
    0b00111100,
    0b00111100,
    0b00111100,
    0b00111100,
    0b00011000,
    0b00011000,
    0b00011000,
    0b00011000,
    0
};


// Variables
#pragma data_seg(Vars)
// Counts frames
char idx;
char idx2 = 57;
// Player 0 X position
__ma char p0_xpos;
// Player 0 Y position
char p0_ypos;

void main() {

    asm { cld }
    // Player 0
    // - Color
    TIA->COLUP0 = 0xf0;
    // - Graphics
    TIA->GRP0 = 0xaf;

    // Player 1
    // - Color
    //TIA->COLUP1 = 0xf0;
    // - Graphics
    //TIA->GRP1 = 0xf5;

    while(1) {

        // Vertical Sync
        // here we generate the signal that tells the TV to move the beam to the top of
        // the screen so we can start the next frame of video.
        // The Sync Signal must be on for 3 scanlines.
        TIA->VSYNC = 2; // D1=1, turns on Vertical Sync signal
        RIOT->TIM64T = (41*CYCLES_PER_SCANLINE)/64; // Set timer to wait 41 lines
        TIA->WSYNC = 0; // Wait for Sync - halts CPU until end of 1st scanline of VSYNC
        TIA->WSYNC = 0; // wait until end of 2nd scanline of VSYNC
        TIA->WSYNC = 0; // wait until end of 3rd scanline of VSYNC
        TIA->VSYNC = 0; // D1=0, turns off Vertical Sync signal

        // Vertical Blank - game logic
        // Since we have a timer running this may take variable time

        // Vertical Sprite Position Player 0 - inline ASM to achieve cycle exact code
        asm { 
            lda p0_xpos
            sta TIA_WSYNC
            sec
        !:  sbc #$f
            bcs !-
            eor #7
            asl
            asl
            asl
            asl
            sta TIA_HMP0
            sta TIA_RESP0
        }
        p0_xpos = SINTABLE_160[idx++];
        p0_ypos = SINTABLE_160[idx2++];

        // Execute horisontal movement

        TIA->WSYNC = 0;
        TIA->HMOVE = 0;

        // Wait for the timer to run out
        while(RIOT->INTIM) TIA->WSYNC = 0;

        // Screen - display logic
        // Update the registers in TIA (the video chip) in order to generate what the player sees.
        // For now we're just going to output 192 colored scanlines lines so we have something to see.
        TIA->VBLANK = 0; // D1=1, turns off Vertical Blank signal (image output on)
        TIA->COLUBK = 0x0; // Set background color to black

        // index into p0 (0 when not active)
        char p0_idx = 0;

        for(char i=1;i<192;i++) {
            // Wait for SYNC (halts CPU until end of scanline)
            TIA->WSYNC = 0; 
            TIA->COLUBK = i;
            if(p0_idx) {
                // Player 0 is active - show it
                char gfx = SPRITE_C[p0_idx];
                TIA->GRP0 = gfx;
                if(gfx==0)
                    p0_idx = 0;
                else 
                    p0_idx++;                    
            } else if(p0_ypos==i)
                // Player 0 becomes active
                p0_idx = 1;
        }

        // Start OverScan
        TIA->WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
        TIA->VBLANK = 2; // D1=1 turns image output off
        TIA->COLUBK = 0; // Set background color to black
        RIOT->TIM64T = (27*CYCLES_PER_SCANLINE)/64; // Set timer to wait 27 lines

        // Vertical Blank - game logic
        // Since we have a timer running this may take variable time

        // Wait for the timer to run out
        while(RIOT->INTIM) TIA->WSYNC = 0;

    }
}
