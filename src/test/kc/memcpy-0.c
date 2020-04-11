// Test memcpy - copy charset and screen using memcpy() from stdlib string

#include <c64.c>
#include <string.c>

byte* const CHARSET = 0x2000;
byte* const SCREEN = 0x0400;
byte* const SCREEN_COPY = 0x2400;

void main() {
    *D018 = toD018(SCREEN_COPY, CHARSET);
    memcpy(SCREEN_COPY, SCREEN, 0x0400);
    asm { sei }
    *PROCPORT = PROCPORT_RAM_CHARROM;
    memcpy(CHARSET, CHARGEN, 0x0800);
    *PROCPORT = PROCPORT_BASIC_KERNEL_IO;
    asm { cli }
}