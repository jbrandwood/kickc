// Minimal memset usage

char * const SCREEN = 0x0400;
char * const COLS = 0xd800;

void main() {
    memset(SCREEN, '*', 1000);
    memset(COLS, 0, 1000);
}



// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
void *memset(void *str, char c, unsigned int num) {
    if(num>0) {
        char* end = (char*)str + num;
        for(char* dst = str; dst!=end; dst++)
            *dst = c;
    }
    return str;
}
