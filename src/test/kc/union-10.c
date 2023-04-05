// More extensive union with C99 style designator initialization behaviour of the second element.

struct Move {
    char f;
    char t;
    char s;
};

struct Turn {
    char t;
    char s;
    char r;
    char d;
};

union Data {
    struct Move m;
    struct Turn t;
};

union Data data = { .t={1,2,3,4} };

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = data.m.f;
}