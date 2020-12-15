// Example program for the Commander X16
// Displays text on the screen by transfering data to VERA

#pragma target(cx16) 
#include <cx16.h>

void main() {

    // Copy message to screen one char at a time
    char MSG[] = "hello world!";
    char* vaddr = DEFAULT_SCREEN;
    for(char i=0;MSG[i];i++) {
        vpoke(0, vaddr++, MSG[i]); // Message
        vpoke(0, vaddr++, 0x21); // Red background, White foreground
    }

    // Copy message (and colors) to screen using memcpy_to_vram
    char MSG2[] = "h e l l o   w o r l d ! "; // Space is 0x20, red background black foreground
    memcpy_to_vram(0, DEFAULT_SCREEN+0x100, MSG2, sizeof(MSG2));

}

