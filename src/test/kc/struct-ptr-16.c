// Demonstrates problem with returning a dereferenced pointer to a struct

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

struct Point* p0 = 0xa000;
struct Point* p1 = 0xb000;
struct Point* p2 = 0xe000;

struct Point get(char i) {
    if(i==0) {
        return *p0;
    } else if(i==1) {
        return *p1;
    } else {
        return *p2;
    }
}