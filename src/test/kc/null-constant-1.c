// Test the NULL pointer

#include <stddef.h>

void main() {
    char* SCREEN = (char*)0x0400;

    SCREEN[1] = get(SCREEN);
    SCREEN[0] = get(NULL);

}

char get(char* ptr) {
    if(NULL==ptr)
        return 0;
    return *ptr;
}