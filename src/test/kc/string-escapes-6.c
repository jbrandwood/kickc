// Test using some simple supported string escape
// Uses \0 to add null-characters

char MESSAGE[] = "a\0bb\0ccc\0";

char * const SCREEN = (char*)0x0400;

void main() {
    char i=0;
    while(MESSAGE[i]) {
        while(MESSAGE[i]) {
            SCREEN[i] = MESSAGE[i];
            i++;
        }
        SCREEN[i] = ' ';
        i++;
    }
}