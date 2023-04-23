// Test __varcall calling convention
// Struct return value

struct Cols {
    char border;
    char bg;
};

struct Cols * const COLS = (struct Cols * const)0xd020;

struct Cols a;

__varcall struct Cols make(char v) {
    struct Cols c;
    c.border = v;
    c.bg = v+v;
    return c;
}

void main() {
     a = make(1);
    *COLS = a;
    a = make(2);
    *COLS = a;
}

