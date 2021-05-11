// Test of simple enum - two-value enum

enum State { OFF , ON };

void main() {
    enum State state = ON;
    byte* const SCREEN = (byte*)0x0400;
    *SCREEN = state;
}