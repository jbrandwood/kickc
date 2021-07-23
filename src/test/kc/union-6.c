// Minimal union with C-Standard behavior - union initializer with first element smaller than second

typedef union Data {
   unsigned char b;
   unsigned int w;
} Data;

Data data  = { 12 };

char* const SCREEN = (char*)0x0400;

void main() {
    data.w = 0x1234;
    SCREEN[0] = BYTE1(data.w);
    SCREEN[1] = BYTE0(data.w);
}