// Test the music player

#pragma target(c64)
#pragma emulator("C64Debugger")
#include <c64.h>
#include <6502.h>


// SID tune
__address(0x3000) char INTRO_MUSIC[] = kickasm(resource "pacman-2chn-simpler.prg") {{
    .const music = LoadBinary("pacman-2chn-simpler.prg", BF_C64FILE)
    .fill music.getSize(), music.get(i)
}};

// Pointer to the music init routine
void()* const musicInit = (void()*) INTRO_MUSIC+0x00;
// Pointer to the music play routine
void()* const musicPlay = (void()*) INTRO_MUSIC+0x06;


void main() {

    asm {
        // Disable SID CH3
        //lda #1
        //sta INTRO_MUSIC+$69
    }

    asm { lda #0 }
    (*musicInit)();

    for(;;) {
        while(VICII->RASTER!=0xfe) ;
        (*musicPlay)();
    }

}




