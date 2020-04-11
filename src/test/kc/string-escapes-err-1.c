// Test errors using string escape sequences
// Unsupported escape sequence

char MESSAGE[] = "qwe\qasd";
char* SCREEN = 0x0400;

void main() {
    byte i=0;
    while(MESSAGE[i])
        SCREEN[i] = MESSAGE[i++];
}