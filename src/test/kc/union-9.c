// Minimal union with C99 style designator initialization behaviour.

union Data {
    char b;
    unsigned w;
};

union Data data = { .w=1234 };

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = data.b;
}