// Support for sizeof() in const pointer definition

// Commodore 64 processor port
char * const SCREEN = (char*)0x0400 +sizeof(char)*100;
void main() {
    SCREEN[0] = 'a';
}