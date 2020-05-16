// Minimal Atari 2600 VCS Program
#pragma target(atari2600)

char * const VSYNC = 0x00;
char * const VBLANK = 0x01;
char * const WSYNC = 0x02;
char * const BACKGROUND_COLOR = 0x09;

char __mem col=0;

void main() {
    while(1) {

        // Vertical Sync
        // here we generate the signal that tells the TV to move the beam to the top of
        // the screen so we can start the next frame of video.
        // The Sync Signal must be on for 3 scanlines.
        *WSYNC = 2; // Wait for SYNC (halts CPU until end of scanline)
        *VSYNC = 2; // Accumulator D1=1, turns on Vertical Sync signal
        *WSYNC = 2; // Wait for Sync - halts CPU until end of 1st scanline of VSYNC
        *WSYNC = 2; // wait until end of 2nd scanline of VSYNC
        *WSYNC = 0; // wait until end of 3rd scanline of VSYNC
        *VSYNC = 0; // Accumulator D1=0, turns off Vertical Sync signal

        // Vertical Blank - game logic
        // Since we don't have any yet, just delay 
        for(char i=0;i<37;i++) {
            *WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
        }

        // Screen - display logic
        // Update the registers in TIA (the video chip) in order to generate what the player sees.  
        // For now we're just going to output 192 colored scanlines lines so we have something to see.
        *VBLANK = 0; // D1=1, turns off Vertical Blank signal (image output on)
        char c = col++;
        for(char i=0;i<192;i++) {
            *WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
            *BACKGROUND_COLOR = c++; // Set background color
        }

        // Overscan - game logic
        // Since we don't have any yet, just delay 
        *WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
        *VBLANK = 2; // // D1=1 turns image output off
        *BACKGROUND_COLOR = 0;
        for(char i=0;i<07;i++) {
            *WSYNC = 0; // Wait for SYNC (halts CPU until end of scanline)
        }

    }
}
