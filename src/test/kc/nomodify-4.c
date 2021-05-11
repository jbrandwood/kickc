// Test that a nomodify parameter works

void main() {
    print('a');
    print('b');
}

char* const SCREEN = (char*)0x0400;

void print(const char c) {
    *SCREEN = c;
}