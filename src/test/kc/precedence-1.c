// Tests ASM constant operator precedence


void main() {

    char * const SCREEN = (char*)0x0400;

    SCREEN[0] = 1+2*3*4+5*6|7;


}