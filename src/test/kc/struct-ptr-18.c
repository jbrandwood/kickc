// Demonstrates problem with passing struct array element as parameter to call

char* const SCREEN = (char*)0x0400;
char idx = 0;

struct Point {
    char x;
    char y;
};

struct Point points[2];

void main() {
    points[0] = { 1, 2 };
    points[1] = { 3, 4 };
    for ( char i: 0..1) {
        print(points[i]);
    }
}

void print(struct Point p) {
    SCREEN[idx++] = p.x;
    SCREEN[idx++] = p.y;
}