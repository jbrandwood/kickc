
typedef unsigned int WORD;

char* const SCREEN = 0x0400;

char* ptr = 0x1000;

void main() {
    WORD w = (WORD)&ptr;
    w += 50;
    SCREEN[0] = <w;
}