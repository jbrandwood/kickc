// Test an empty statement ';'

const char str[] = "Hello!";
const char* SCREEN = 0x0400;

void main() {
    char b = 0;
    for (; str[b] != 0; ++b) ; // Empty body
    SCREEN[0] = '0'+b;
}
