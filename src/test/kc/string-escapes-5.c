// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code that do not exist with the encoding.

#pragma encoding(petscii_mixed)
char MESSAGE[] = "qwe\xffasd\xferty";

char CH = '\xff';

char * const SCREEN = 0x0400;

void main() {
    char i=0;
    while(MESSAGE[i])
        SCREEN[i] = MESSAGE[i++];
    SCREEN[0x28] = CH;
}