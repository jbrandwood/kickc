
unsigned char bram[100];
unsigned char *bram_base = (unsigned char*)&bram;

char * const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = *bram_base++;
    SCREEN[1] = *bram_base++;
}