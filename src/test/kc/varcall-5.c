// Test __varcall calling convention
// Struct return value

struct Cols {
    char border;
    char bg;
};

struct Cols * const COLS = (struct Cols *)0xd020;

struct Cols a;

void main() {
     a = make(1);
    *COLS = a;
    a = make(2);
    *COLS = a;
}

__varcall struct Cols make(char v) {
    return { v,  v+v };
}
