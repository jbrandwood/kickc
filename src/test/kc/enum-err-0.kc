// Test of simple enum error - name already used

byte ON = 17;

enum State {
        OFF,
        ON
    };

void main() {
    enum State state = ON;
    byte* const SCREEN = 0x0400;
    *SCREEN = state;
}

