// A simple SID music player playing music in the main loop.
#include <c64.h>

char* const MUSIC = $1000;

// Load the SID
kickasm(resource "toiletrensdyr.sid") {{
    .const music = LoadSid("toiletrensdyr.sid")
}}

// Place the SID into memory
kickasm(pc MUSIC) {{
    .fill music.size, music.getData(i)
}}


// Play the music 
void main() {
    // Initialize the music
    asm {  jsr music.init }
    do {
        // Wait for the RASTER
        do {} while (VICII->RASTER != $fd);
        (VICII->BORDER_COLOR)++;
        // Play the music
        asm { jsr music.play }
        (VICII->BORDER_COLOR)--;
    } while (true);
}