// Test the preprocessor
// Macro generating inline ASM

#define SEI asm { sei }
#define CLI asm { cli }

char * SCREEN = 0x0400;
char idx = 0;

void main() {
    SEI
    SCREEN[idx++] = 'x';
    CLI
}