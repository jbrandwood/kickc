// Minimal Atari 2600 VCS Program
// Source: https://atariage.com/forums/blogs/entry/11109-step-1-generate-a-stable-display/
#pragma target(atari2600)
#include <atari2600.h>

// Variables
#pragma data_seg(Vars)
char __mem idx=0;

// Data
#pragma data_seg(Data)
const char SINTABLE[0x100] = kickasm {{
    .fill $100, round(127.5+127.5*sin(2*PI*i/256))
}};

void main() {

    TIA->PF0 = 0b10100000;
    TIA->PF1 = 0b01010101;
    TIA->PF2 = 0b10101010;
    TIA->COLUPF = 0x55;

    while(1) {

        // Vertical Sync
        // here we generate the signal that tells the TV to move the beam to the top of
        // the screen so we can start the next frame of video.
        // The Sync Signal must be on for 3 scanlines.
        TIA->VSYNC = 2; // D1=1, turns on Vertical Sync signal
        RIOT->TIM64T = (41*76)/64; // Set timer to wait 41 lines
        TIA->WSYNC = 0; // Wait for Sync - halts CPU until end of 1st scanline of VSYNC
        TIA->WSYNC = 0; // wait until end of 2nd scanline of VSYNC
        TIA->WSYNC = 0; // wait until end of 3rd scanline of VSYNC
        TIA->VSYNC = 0; // D1=0, turns off Vertical Sync signal

        // Vertical Blank - game logic
        // Since we have a timer running this may take variable time


        // Wait for the timer to run out
        while(RIOT->INTIM) TIA->WSYNC = 0;

        // Screen - display logic
        // Update the registers in TIA (the video chip) in order to generate what the player sees.
        // For now we're just going to output 192 colored scanlines lines so we have something to see.
        TIA->VBLANK = 0; // D1=1, turns off Vertical Blank signal (image output on)
        char c = SINTABLE[idx++];
        for(char i=0;i<192;i++) {
            TIA->WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
            TIA->COLUBK = c; // Set background color
            TIA->PF0 = c;
            TIA->PF1 = c;
            TIA->PF2 = c;
            TIA->HMOVE = c;
            c++;
        }

        // Start OverScan
        TIA->WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
        TIA->VBLANK = 2; // D1=1 turns image output off
        TIA->COLUBK = 0; // Set background color to black
        RIOT->TIM64T = (27*76)/64; // Set timer to wait 27 lines

        // Vertical Blank - game logic
        // Since we have a timer running this may take variable time

        // Wait for the timer to run out
        while(RIOT->INTIM) TIA->WSYNC = 0;


    }
}
