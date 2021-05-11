// Test of simple enum error - name already used

enum State {
        OFF,
        ON,
        OFF
};

void main() {
    enum State state = ON;
    byte* const SCREEN = (char*)0x0400;
    *SCREEN = state;
}

