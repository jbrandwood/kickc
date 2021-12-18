// Test errors using string escape sequences
// Half hex-escape

char MESSAGE[] = "qwe\x";
char* SCREEN = (char*)0x0400;

void main() {
    byte i=0;
    while(MESSAGE[i])
        SCREEN[i] = MESSAGE[i++];
}