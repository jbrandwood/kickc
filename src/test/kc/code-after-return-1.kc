// Test code after return in main()

char* const SCREEN = 0x0400;

char b = 0;

void main() {
    SCREEN[0] = b;
    return;
    bb();
    SCREEN[1] = b;
}

void bb(){
    b++;
}
