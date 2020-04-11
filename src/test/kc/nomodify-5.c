// Test that modifying a nomodify-parameter fails as expected

void main() {
    print('a');
    print('b');
}

char* const SCREEN = 0x0400;

void print(const char c) {
    *SCREEN = c++;
}