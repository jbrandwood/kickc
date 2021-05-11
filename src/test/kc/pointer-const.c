// Test pointer to const and const pointer

// Pointer to const
char const * MSG = "hello world!";

// Const pointer
char * const SCREEN = (char*)0x0400;

// Const pointer to const
char const * const BASIC = (char*)0xa004;

void main() {
    char i=0;
    while(MSG[i]) {
        SCREEN[i] = MSG[i];
        i++;
    }
    i=0;
    while(BASIC[i]!='0') {
        SCREEN[40+i] = BASIC[i]&0x3f;
        i++;
    }
}