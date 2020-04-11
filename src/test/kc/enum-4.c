// Test of simple enum - inline enum definitions

void main() {
    enum State { OFF,  ON } state = ON;
    byte* const SCREEN = 0x0400;
    *SCREEN = state;
}

