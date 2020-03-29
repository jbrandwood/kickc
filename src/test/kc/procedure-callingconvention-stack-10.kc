// Test a procedure with calling convention stack
// Returning and passing struct values

#pragma calling(__stackcall)

char* const SCREEN = 0x0400;
char idx = 0;

struct Point {
    char x;
    char y;
};

void main(void) {
    for(char i=0;i<5;i++) {
        struct Point p = get(i);
        print(p);
    }
}

struct Point get(char i) {
    struct Point p = { i, i/2 };
    return p;
}

void print(struct Point p) {
    SCREEN[idx++] = p.x;
    SCREEN[idx++] = p.y;
}





