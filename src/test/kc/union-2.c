// Minimal union with C-Standard behavior - union nested inside struct

struct Jig {
    enum Type { BYTE , WORD } type;
    union Data {
        char b;
        unsigned w;
    } data;
};

struct Jig jig;

char* const SCREEN = (char*)0x0400;

void main() {
    jig.type = WORD;
    jig.data.w = 0x1234;
    SCREEN[0] = jig.type;
    SCREEN[1] = jig.data.b;
}