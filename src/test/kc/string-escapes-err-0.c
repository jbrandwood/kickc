// Test errors using string escape sequences
// Unfinished escape at end of string

char MESSAGE[] = "qwe\";
char* SCREEN = (char*)0x0400;

void main() {
    byte i=0;
    while(MESSAGE[i])
        SCREEN[i] = MESSAGE[i++];
}