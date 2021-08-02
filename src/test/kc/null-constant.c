// Test the NULL pointer

#include <stddef.h>

char * screen = NULL;

char * ptrs[] = { (char*)0x400, (char*)0x450, (char*)0x4a0, NULL };

void main() {
    for(char ** ptr = ptrs; *ptr; ptr++) {
        **ptr = 'a';
        screen = *ptr;
        screen[1] = 'b';
    }

}