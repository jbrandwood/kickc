// Test a struct array initialized with to few members (zero-filled for the rest)

struct Point {
    char x;
    int y;
};

struct Point points[4] = { { 1, 2111 }, { 3, 4222 } };

void main() {
    for ( char i: 0..3) {
        print(points[i]);
    }
}

char* const SCREEN = (char*)0x0400;
char idx = 0;

void print(struct Point p) {
    SCREEN[idx++] = p.x;
    SCREEN[idx++] = <p.y;
    SCREEN[idx++] = >p.y;
    SCREEN[idx++] = ' ';
}