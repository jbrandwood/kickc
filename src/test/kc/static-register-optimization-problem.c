// https://gitlab.com/camelot/kickc/issues/336
// ASM Static Register Value analysis erronously believes >-1 == 0

void main() {
    char* screen = (char*)0x0400;
    int lasti = -1;
    for(int i=0;i<10;i++) {
        screen[i] = (char)lasti;
        lasti = i;
    }
}