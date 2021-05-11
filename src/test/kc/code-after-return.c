// Test code after return in main()

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = 'a';
    return;
    SCREEN[1] = 'a';
}