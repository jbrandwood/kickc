// Test of simple enum error - name already used

byte val;

enum State {
        OFF,
        ON = val
};

void main() {
    enum State state = ON;
    byte* const SCREEN = (char*)0x0400;
    *SCREEN = state;
}

