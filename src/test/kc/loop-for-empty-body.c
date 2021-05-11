// Test a for-loop with an empty body

const char str[] = "Hello!";
char* const SCREEN = (char*)0x0400;

void main() {
    char b = 0;
    for (; str[b] != 0; ++b) {} // Empty body
    SCREEN[0] = '0'+b;
}