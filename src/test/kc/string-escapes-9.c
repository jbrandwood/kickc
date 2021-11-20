// Test octal escapes in strings

char MESSAGE[] = "\1\01\001\377";
char* SCREEN = (char*)0x0400;

void main() {
    byte i=0;
    while(MESSAGE[i])
        SCREEN[i] = MESSAGE[i++];
}