// Demonstrates problem with passing struct pointer deref as parameter to call

char* const SCREEN = 0x0400;
char idx = 0;

struct Point {
    char x;
    char y;
};

void main() {
    struct Point point = { 1, 2 };
    struct Point* ptr = &point;
    print(point);
    print(*ptr);
}

void print(struct Point p) {
    SCREEN[idx++] = p.x;
    SCREEN[idx++] = p.y;
}