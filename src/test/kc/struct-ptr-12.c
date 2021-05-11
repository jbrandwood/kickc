// Minimal struct -  using address-of
struct Point {
    byte x;
    byte y;
};

void main() {
    volatile struct Point p = { 2, 3 };
    struct Point *q = &p;
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = q->x;
    SCREEN[1] = q->y;
}