// Tests ATASCII encoding

#pragma encoding(atascii)
char TEXT[] = "hello, world!\n";

char * SCREEN = 0x0400;

void main() {
    SCREEN[0] = TEXT[13];
    SCREEN[1] = '\n';
}