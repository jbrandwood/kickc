// Minimal union with C-Standard behavior - union return value

union Data {
   unsigned int w;
   unsigned char b;
};

char* const SCREEN = (char*)0x0400;
char idx = 0;

void main() {
    union Data d1 = data(0x1234);
    SCREEN[idx++] = d1.b;
    union Data d2 = data(0x5678);
    SCREEN[idx++] = d2.b;
}

union Data data(unsigned int i) {
    return { i };
}