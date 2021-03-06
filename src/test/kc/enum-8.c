// Test of simple enum - struct with inline anonymous enum

struct Button {
    enum { RED=2, GREEN=5 } color;
    byte size;
};

void main() {
    struct Button button = { RED, 24 };
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = button.color;
    SCREEN[1] = button.size;
}

