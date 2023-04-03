// Test __varcall calling convention
// Struct of struct parameter value

struct Col {
    char border;
    char bg;
};

struct Cols {
    struct Col normal;
    struct Col error;
};

char * const COLS = (char*)0xd020;

__varcall char plus(struct Cols a, struct Cols b) {
    return a.normal.border + b.normal.border + a.normal.bg + b.normal.bg + a.error.border + b.error.border + a.error.bg + b.error.bg;
}

void main() {
    struct Cols a = { { 1, 2 }, { 3, 4 }};
    struct Cols b = { { 5, 6 }, { 7, 8 }};
    struct Cols c = { { 9, 10 }, { 11, 12 }};
    *COLS = plus(a, b);
    *COLS = plus(b, c);
}
