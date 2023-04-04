// More extensive union with C99 style designator initialization behaviour using const expressions.

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

const struct Move move = {1,2,3};

union Data data = { .m=move };

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = data.m.f;
}