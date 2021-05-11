
// Minimal classic for() loop - coded using while() to test optimization of loop heads

typedef word size_t ;

char* SCREEN = (char*)0x0400;

void main() {
    memset(SCREEN, 'c', 1000);
}

// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
void *memset(void *str, char c, size_t num) {
    if(num>0) {
        char* end = (char*)str + num;
        char* dst = str;
        while(dst!=end) {
            *dst = c;
            dst++;
        }
    }
    return str;
}
