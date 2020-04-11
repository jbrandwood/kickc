// Test using some simple supported string escape characters in PETSCII

#pragma encoding(petscii_mixed)

char MESSAGE[] = "hello\nworld\\";

char* const memA = 0xff;

void main() {
    byte i=0;
    while(MESSAGE[i])
        chrout(MESSAGE[i++]);
}

void chrout(char c) {
    *memA = c;
    asm {
        lda memA
        jsr $ffd2
        }
}