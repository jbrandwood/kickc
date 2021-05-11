// Test the preprocessor
// Test multi-line macro

#define PRINTXX \
    SCREEN[idx++] = 'x'; \
    SCREEN[idx++] = 'x'

char * SCREEN = (char*)0x0400;
char idx = 0;

void main() {
    SCREEN[idx++] = '-';
    PRINTXX;
    SCREEN[idx++] = '-';
}