// Fill screen using a pointer

char * SCREEN = (char*)0x0400;

void main() {
    for(char* dst = SCREEN; dst!=SCREEN + 1000; dst++)
        *dst = ' ';
}
