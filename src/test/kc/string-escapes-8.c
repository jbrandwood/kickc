// Support for '\0' literal character
char * const SCREEN = (char*)0x0400;
void main(void) {
    SCREEN[0] = '\0';
}