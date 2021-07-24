// Test __varcall calling convention
// Struct parameter & return value

struct Cols {
    char border;
    char bg;
};

struct Cols * const COLS = (struct Cols *)0xd020;

void main() {
    struct Cols a = { 1, 2 };
    //*COLS = a;
    a = plus(a, { 2, 3 } );
    *COLS = a;
    //a = plus(a, a);
    //*COLS = a;
}

__varcall struct Cols plus(struct Cols a, struct Cols b) {
    return { a.border+b.border,  a.bg+b.bg };
}