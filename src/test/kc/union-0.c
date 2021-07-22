// Minimal union with C-Standard behavior

union Data {
    char b;
    unsigned w;
};

union Data data;

char* const SCREEN = (char*)0x0400;

void main() {
    data.w = 1234;
    SCREEN[0] = data.b;
}