// An 8x8 char letter scroller
#include <c64.h>

char* SCREEN = $0400;
char* TEXT = "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     ";

void main() {
    fillscreen(SCREEN, $20);
    do {
        // Wait for raster
        do {} while(VICII->RASTER!=$fe);
        do {} while(VICII->RASTER!=$ff);
        ++VICII->BG_COLOR;
        scroll_soft();
        --VICII->BG_COLOR;
    } while(true);
}

// Soft-scroll using $d016 - trigger bit-scroll/char-scroll when needed
char scroll = 7;
void scroll_soft() {
    if(--scroll==$ff) {
        scroll = 7;
        scroll_bit();
    }
    VICII->CONTROL2 = scroll;
}

// Scroll the next bit from the current char onto the screen - trigger next char if needed
char* current_chargen = CHARGEN;
char current_bit = 1;
void scroll_bit() {
    current_bit = current_bit/2;
    if(current_bit==0) {
        unsigned int c = next_char();
        current_chargen = CHARGEN+c*8;
        current_bit = $80;
    }
    scroll_hard();
    asm { sei }
    *PROCPORT = $32;
    char* sc = SCREEN+40+39;
    for(char r:0..7) {
        char bits = current_chargen[r];
        char b = ' ';
        if((bits & current_bit) != 0) {
            b = 128+' ';
        }
        *sc = b;
        sc = sc+40;
    }
    *PROCPORT = $37;
    asm { cli }
}

char* nxt = TEXT;
// Find the next char of the scroll text
char next_char() {
  char c = *nxt;
  if(c==0) {
    nxt = TEXT;
    c = *nxt;
  }
  nxt++;
  return c;
}

void scroll_hard() {
    // Hard scroll
    for(char i=0;i!=39;i++) {
        (SCREEN+40*0)[i]=(SCREEN+40*0)[i+1];
        (SCREEN+40*1)[i]=(SCREEN+40*1)[i+1];
        (SCREEN+40*2)[i]=(SCREEN+40*2)[i+1];
        (SCREEN+40*3)[i]=(SCREEN+40*3)[i+1];
        (SCREEN+40*4)[i]=(SCREEN+40*4)[i+1];
        (SCREEN+40*5)[i]=(SCREEN+40*5)[i+1];
        (SCREEN+40*6)[i]=(SCREEN+40*6)[i+1];
        (SCREEN+40*7)[i]=(SCREEN+40*7)[i+1];
    }
}

// Fill the screen with one char
void fillscreen(char* screen, char fill) {
    for( char* cursor = screen; cursor < screen+1000; cursor++) {
        *cursor = fill;
    }
}
