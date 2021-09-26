#pragma var_model(mem)
#pragma zp_reserve(0x91, 0x99, 0xa0, 0xa1, 0xa2, 0xc0, 0xc5, 0xc6, 0xcb, 0xcc )

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