// Test __varcall calling convention
// Pointer to Struct parameter & return value

struct Cols {
    char border;
    char bg;
};

struct Cols * const COLS = (struct Cols *)0xd020;

__varcall struct Cols * min(struct Cols * a, struct Cols * b) {
    if(a->bg < b->bg)
        return a;
    else
        return b;

}


void main() {
    struct Cols a = { 1, 7 };
    struct Cols b = { 2, 6 };
    struct Cols c = { 3, 5 };
    struct Cols *m = min(&a,&b);
    *COLS = *m;
    m = min(m,&c);
    *COLS = *m;
}
