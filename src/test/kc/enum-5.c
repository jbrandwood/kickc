// Test of simple enum - multiple inline enum definitions

void main() {
    enum State { OFF,  ON } state = ON;
    byte* const SCREEN = (byte*)0x0400;
    *SCREEN = state;
    test();
}

void test() {
    enum State { OFF=7,  ON } state = ON;
    byte* const SCREEN = (byte*)0x0428;
    *SCREEN = state;
}
