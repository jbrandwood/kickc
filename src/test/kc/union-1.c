// Minimal union with C-Standard behavior - union nested inside struct

union Data {
    char b;
    unsigned w;
};

struct Jig {
    enum Type { BYTE , WORD } type;
    union Data data;
};

struct Jig jig;

char* const SCREEN = (char*)0x0400;

void main() {
    jig.type = WORD;
    jig.data.w = 1234;
    SCREEN[0] = jig.type;
    SCREEN[0] = jig.data.b;
}