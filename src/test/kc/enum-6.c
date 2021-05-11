// Test of simple enum - anonymous enum definition

void main() {
    enum { OFF,  ON } state = ON;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = state;
    state = OFF;
    SCREEN[1] = state;
}

