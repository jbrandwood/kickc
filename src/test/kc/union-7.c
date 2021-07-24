// Minimal union with C-Standard behavior - union parameter

union Data {
   unsigned char b;
   unsigned int w;
};

union Data data1 = { 0x12 };
union Data data2 = { 0x34 };

void main() {
    print(data1);
    print(data2);
}

char* const SCREEN = (char*)0x0400;
char idx = 0;

void print(union Data data) {
    SCREEN[idx++] = BYTE1(data.w);
    SCREEN[idx++] = data.b;
    SCREEN[idx++] = ' ';
}