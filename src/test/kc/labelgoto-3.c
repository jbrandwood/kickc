// Test labels/goto
// an infinite loop using goto

void main() {
    char * const SCREEN = (char*)0x0400;
    char i=0;
    repeat:
    SCREEN[i++] = '*';
    goto repeat;
}