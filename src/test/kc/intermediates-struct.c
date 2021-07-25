// Test intermediate vars

// #pragma struct_model(classic)

char * const SCREEN = (char*)0x0400;
char idx = 0;

struct Data {
    char c;
    char d;
};

void main() {
    struct Data x = sum(1,2);
    SCREEN[idx++] = x.c;
    struct Data y = sum(3, 4);
    SCREEN[idx++] = y.d;
}

struct Data sum(char a,char b) {
    __ma struct Data d = { a+b, b };
    return d;
}

