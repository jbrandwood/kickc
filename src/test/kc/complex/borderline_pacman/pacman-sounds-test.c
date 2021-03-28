// Sound effects for pacman

#pragma target(c64)
#pragma emulator("C64Debugger")
#include <c64.h>
#include <conio.h>
#include <6502.h>

#include "pacman-sounds.c"

void main() {

    // Prevent Interrupt
    SEI();

    pacman_sound_init();
    pacman_ch1_enabled = 1;

    for(;;) {
        // Wait for raster
        while(VICII->RASTER!=0xfe) ;
        VICII->BORDER_COLOR = WHITE;
        pacman_sound_play();
        VICII->BORDER_COLOR = BLUE;
        while(VICII->RASTER!=0x10) ;
        if(kbhit()) 
            pacman_ch1_enabled = 1;
    }

}
