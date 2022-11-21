// Test a procedure with calling convention stack
// Returning and passing struct values

#pragma calling(__stackcall)
#pragma struct_model(classic)

char* const SCREEN = (char*)0x0400;
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

struct Point __bank(ram,1) get(char i) {
    struct Point p = { i, i/2 };
    return p;
}

void __bank(ram,2) print(struct Point p) {
    SCREEN[idx++] = p.x;
    SCREEN[idx++] = p.y;
}





