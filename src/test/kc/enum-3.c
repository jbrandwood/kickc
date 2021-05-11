// Test of simple enum - value with complex calculation

enum State {
    OFF,
    ON=4*4+2,
    BROKEN
    };

void main() {
    enum State state = BROKEN;
    byte* const SCREEN = (byte*)0x0400;
    *SCREEN = state;
}