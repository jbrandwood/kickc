// Typedef const/volatile type

char* const SCREEN = (char*)0x0400;

typedef const char C;
typedef volatile char V;

const C c = 'c';
volatile V v = 'v';

void main() {
    SCREEN[0] = c;
    SCREEN[1] = v;
}