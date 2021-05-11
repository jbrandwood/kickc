// Test the preprocessor
// Macro with parameters

#define SQUARE(x) x*x
#define DOUBLE(x) SUM(x,x)
#define SUM(x,y) x+y

char * SCREEN = (char*)0x0400;

void main() {
    char idx = 0;
    SCREEN[idx++] = SUM('0',4);
    SCREEN[idx++] = DOUBLE('b');
    SCREEN[idx++] = SQUARE('c');
}