// Testing binary to hex conversion using pointer to pointer

void main() {
    cls();
    unsigned char *screen = 0x0400;
    utoa16w(00000, screen); screen += 40;
    utoa16w(01234, screen); screen += 40;
    utoa16w(05678, screen); screen += 40;
    utoa16w(09999, screen); screen += 40;
    utoa16w(58888, screen);
}

void cls() {
    unsigned char *screen = 0x0400;
    for( unsigned char *sc: screen..screen+999) *sc=' ';
}

// Digits used for utoa()
unsigned char DIGITS[] = "0123456789abcdef";

// Hexadecimal utoa() for an unsigned int (16bits)
void utoa16w(unsigned int value, unsigned char* dst) {
    unsigned char started = 0;
    started = utoa16n((>value)>>4, &dst, started);
    started = utoa16n((>value)&0x0f, &dst, started);
    started = utoa16n((<value)>>4, &dst, started);
    utoa16n((<value)&0x0f, &dst, 1);
    *dst = 0;
}

// Hexadecimal utoa() for a single nybble
unsigned char utoa16n(unsigned char nybble, unsigned **dst, unsigned char started) {
    if(nybble!=0) started=1;
    if(started!=0) {
        *(*dst)++ = DIGITS[nybble];
    }
    return started;
}
