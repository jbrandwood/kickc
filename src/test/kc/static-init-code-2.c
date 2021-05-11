// Tests static initialization code
// No initializer code should be needed (since all values are constant)

char c1 = 'o';
char c2 = 'k';

char * const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = c1;
    SCREEN[1] = c2;
}

