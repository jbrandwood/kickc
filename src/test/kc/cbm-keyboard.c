
#pragma zp_reserve(0x73..0x8a)  // CHRGET routine: fetches next character of BASIC program text
#pragma zp_reserve(0x91)        // Keyboard Flag. 127 = STOP , 223 = C= , 239 = SPACE , 251 = CTRL , 255 = no key pressed
#pragma zp_reserve(0x99)        // Current input device: defaults to 0 = keyboard
#pragma zp_reserve(0xa0..0xa2)  // Software jiffy clock, updated by KERNAL IRQ every 1/60 second
#pragma zp_reserve(0xc0)        // Cassette motor flag 0 = off, 1 = on
#pragma zp_reserve(0xc5)        // Matrix coordinate of last pressed key, 64 = none
#pragma zp_reserve(0xc6)        // Number of characters in keyboard buffer
#pragma zp_reserve(0xcb)        // Index to keyboard decoding table for currently pressed key, 64 = no key was depressed
#pragma zp_reserve(0xcc)        // Flash cursor flag 0 = yes, otherwise no
#pragma zp_reserve(0xd0) 	    // Input from 0 = keyboard or 3 = screen
#pragma zp_reserve(0xf5..0xf6)  // Keyboard decoding table

#include <6502.h>
#include <c64.h>
#include <stdio.h>
#include <conio.h>

// Show the currently pressed key
int main(void) {
    VICII->MEMORY = toD018(DEFAULT_SCREEN, DEFAULT_FONT_MIXED);
    clrscr();
    char current = 0;
    for(;;) {
        char ch = GETIN();
        if(ch && ch!=current) {
            printf("'%c'($%2x) ", petscii_to_screencode(ch), ch);
            current = ch;
        }
    }
}

// Convert a PETSCII char to screencode
char petscii_to_screencode(char petscii) {
    if(petscii<32)
        return petscii+128;
    else if(petscii<64)
        return petscii;
    else if(petscii<96)
        return petscii-64;
    else if(petscii<128)
        return petscii-32;
    else if(petscii<160)
        return petscii+64;
    else if(petscii<255)
        return petscii-128;
    else // ==255
        return 0x5e;
}


// GETIN. Read byte from default input. (If not keyboard, must call OPEN and CHKIN beforehands.)
// Return: next byte in buffer or 0 if buffer is empty.
char GETIN() {
    char * const ch = (char*)0xff;
    asm {
        jsr $ffe4
        sta ch
    }
    return *ch;
}