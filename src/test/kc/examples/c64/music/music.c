// A simple SID music player playing music in the main loop.
#include <c64.h>

// SID tune at an absolute address
__address(0x1000) char MUSIC[] = kickasm(resource "toiletrensdyr.sid") {{
    .const music = LoadSid("toiletrensdyr.sid")
    .fill music.size, music.getData(i)
}};

typedef void(*PROC_PTR)();

// Pointer to the music init routine
PROC_PTR musicInit = (PROC_PTR) MUSIC;
// Pointer to the music play routine
PROC_PTR musicPlay = (PROC_PTR) MUSIC+3;

// Play the music 
void main() {
    // Initialize the music
    (*musicInit)();
    do {
        // Wait for the RASTER
        do {} while (VICII->RASTER != $fd);
        (VICII->BORDER_COLOR)++;
        // Play the music
        (*musicPlay)();
        (VICII->BORDER_COLOR)--;
    } while (true);
}