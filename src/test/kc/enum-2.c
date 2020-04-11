// Test of simple enum - char values with increment

enum Letter {
    A = 'a',
    B = 'b',
    C
    };

void main() {
    enum Letter letter = B;
    byte* const SCREEN = 0x0400;
    *SCREEN = letter;
}