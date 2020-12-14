// Example program for the Commander X16
// Displays text on the screen by transfering data to VERA

#pragma target(cx16) 
#include <cx16.h>

void main() {
    char MSG[] = "hello world!";
    // Address of the default screen
    char* vaddr = 0x0000;
    for(char i=0;MSG[i];i++) {
        vpoke(0, vaddr++, MSG[i]); // Message
        vpoke(0, vaddr++, 0x21); // Red background, White foreground
    }
}