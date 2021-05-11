// Test the preprocessor
// Macro generating inline kickasm

#define SEI kickasm {{ sei }}
#define CLI kickasm {{ cli }}

char * SCREEN = (char*)0x0400;
char idx = 0;

void main() {
    SEI
    SCREEN[idx++] = 'x';
    CLI
}