// Demonstrates problem with returning a struct into a dereferenced pointer to a struct

struct Point {
    char x;
    char y;
};

struct Point* const SCREEN = 0x0400;
char idx = 0;

void main() {
    *SCREEN = get(0);
    for ( char i: 1..2) {
        SCREEN[i] = get(i);
    }
}

struct Point get(char i) {
    struct Point p = { i, 7 };
    return p;
}