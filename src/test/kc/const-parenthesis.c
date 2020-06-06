// Test parenthesising of constants
// See https://gitlab.com/camelot/kickc/-/issues/470#note_356486132

char * const SCREEN = 0x0400;

void main() {
    const char dy = 128;    
    // A parenthesis should be added in the ASM to ensure operator precedence 
    SCREEN[0] = (dy-1)/16;
    // No parenthesis should be added in the ASM because minus (-) has higher precedence than shift (>>)
    SCREEN[1] = (dy-1)>>4;        
}

