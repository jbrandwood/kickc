// Test #pragma without parenthesis

#pragma target vic20
#pragma constructor_for init main

char * const SCREEN = (char*)0x0400;

void main() {
    SCREEN[1] = 'b';
}

void init() {
    SCREEN[0] = 'a';
}