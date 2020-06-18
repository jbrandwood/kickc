// Tests static initialization code
// No initialization code should call main() directly removing _start() and _init()

char * const SCREEN = 0x0400;

void main() {
    SCREEN[0] = 'o';
    SCREEN[1] = 'k';
}

