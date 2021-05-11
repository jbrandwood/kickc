// Test a procedure with calling convention stack
// Returning and passing struct of struct  values

#pragma calling(__stackcall)

char* const SCREEN = (char*)0x0400;
char idx = 0;

struct Point {
    char x;
    char y;
};

struct Vector {
    struct Point p1;
    struct Point p2;
};


void main(void) {
    for(char i=0;i<5;i++) {
        struct Vector v = get(i);
        print(v);
    }
}

struct Vector get(char i) {
    struct Vector v = { {i, i/2}, {i+1, i*2} };
    return v;
}

void print(struct Vector v) {
    SCREEN[idx++] = v.p1.x;
    SCREEN[idx++] = v.p1.y;
    SCREEN[idx++] = v.p2.x;
    SCREEN[idx++] = v.p2.y;
    SCREEN[idx++] = ' ';
}





