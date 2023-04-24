// More extensive union with C99 style designator initialization behaviour using const expressions.

union A {
    unsigned char b;
    unsigned int w;
};

union B {
    union A a;
    char b[4];
};

union B b1 = { .a={ .b=1 } };


char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = b1.b[0];
}