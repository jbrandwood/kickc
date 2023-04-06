// Test __varcall calling convention
// Struct parameter & return value - only a single call

struct Cols {
    char border;
    char bg;
};

struct Cols * const COLS = (struct Cols *)0xd020;

__varcall struct Cols plus(struct Cols a, struct Cols b) {
    return { a.border+b.border,  a.bg+b.bg };
}


void main() {
    struct Cols a = { 1, 2 };
    struct Cols b = { 2, 3 };
    struct Cols c = plus(a, b);
    *COLS = c;
}
