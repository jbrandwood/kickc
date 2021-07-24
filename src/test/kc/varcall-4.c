// Test __varcall calling convention
// Struct parameter

struct Cols {
    char border;
    char bg;
    char fg;
};

char * const COLS = (char *)0xd020;

struct Cols a = { 1, 2, 3 };
struct Cols b = { 3, 4, 6 };
struct Cols c = { 5, 6, 7 };
struct Cols d;

void main() {
    char sum1 = fg_sum(a, b);
    *COLS = sum1;
    d = b;
    char sum2 = fg_sum(c, d);
    *COLS = sum2;
}

__varcall char fg_sum(struct Cols a, struct Cols b) {
    return a.fg+b.fg;
}