// Test parsing a negated struct reference - which causes problems with the ASMREL labels !a++
// https://gitlab.com/camelot/kickc/issues/266

struct A {
    char b;
};

struct A aa = { 1 };

void main() {
    char* const SCREEN = 0x0400;
    struct A* a = &aa;
    // A negated struct reference!
    if(!a->b) {
        *SCREEN = 'a';
    }

    // ASMREL labels
    asm {
        jmp !a+
    !a:
    }
}