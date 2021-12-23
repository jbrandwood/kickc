// Trivial VIC 20 program
#pragma target(vic20_3k)
#include <vic20.h>

char MESSAGE[] = "hello world!";

void main() {
    for(char i=0; MESSAGE[i]; i++) {
        DEFAULT_SCREEN[i] = MESSAGE[i];
        DEFAULT_COLORRAM[i] = RED;
    }
}