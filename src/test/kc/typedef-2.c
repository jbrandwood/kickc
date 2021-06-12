
typedef unsigned int WORD;

char* const SCREEN = (char*)0x0400;

char* ptr = (char*)0x1000;

void main() {
    WORD w = (WORD)&ptr;
    w += 50;
    SCREEN[0] = BYTE0(w);
}