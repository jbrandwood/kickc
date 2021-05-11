// Experiments with malloc()

#include <stdlib.h>

void main() {
    unsigned char* buf1 = malloc(100);
    unsigned char* buf2 = malloc(100);
    for(unsigned char i:0..99) {
        buf1[i] = i;
        buf2[i] = 255-i;
    }
    free(buf1);
    free(buf2);
    unsigned char* screen = (char*)0x0400;
    screen[0] = *buf1;
    screen[1] = *buf2;
}
