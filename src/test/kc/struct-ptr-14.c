// Minimal struct -  using address-of and passing it to a function
struct Point {
    byte x;
    byte y;
};

void main() {
    volatile struct Point p = { 2, 3 };
    struct Point *q = &p;
    set(q);
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = q->x;
    SCREEN[1] = q->y;
}

void set(struct Point *ptr) {
    ptr->x = 4;
    ptr->y = 5;
}