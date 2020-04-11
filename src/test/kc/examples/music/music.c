// A simple SID music player playing music in the main loop.
#include <c64.c>

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
        do {} while (*RASTER != $fd);
        (*BORDERCOL)++;
        // Play the music
        asm { jsr music.play }
        (*BORDERCOL)--;
    } while (true);
}