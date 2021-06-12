// Testing hex to decimal conversion

unsigned char * const control = (char*)0xd011;
unsigned char * const raster = (char*)0xd012;
unsigned char * const BORDER_COLOR = (char*)0xd020;

void main() {
    asm { sei }
    cls();
    while(true) {
        do {
            unsigned char rst = (*control&0x80)|(*raster>>1);
        } while (rst!=0x30);
        unsigned char *screen = (char*)0x0400;
        *BORDER_COLOR = 1;
        unsigned char time_start = *raster;
        utoa16w(00000, screen); (*BORDER_COLOR)++; screen += 40;
        utoa16w(01234, screen); (*BORDER_COLOR)++; screen += 40;
        utoa16w(05678, screen); (*BORDER_COLOR)++; screen += 40;
        utoa16w(09999, screen); (*BORDER_COLOR)++; screen += 40;
        utoa16w(58888, screen);
        unsigned char time_end = *raster;
        *BORDER_COLOR = 0;
        unsigned char time = time_end - time_start;
        utoa10w((unsigned int)time, screen+80);
        byte msg[] = "raster lines";
        for( byte i=0; msg[i]!=0; i++ ) (screen+80+3)[i] = msg[i];
        //for( byte* m="lines", s=screen+80+6 ;*m!=0;m++,s++) *s = *m;
    }

}

void cls() {
    unsigned char *screen = (char*)0x0400;
    for( unsigned char *sc: screen..screen+999) *sc=' ';
}

const unsigned char RADIX_BINARY = 2;
const unsigned char RADIX_OCTAL = 8;
const unsigned char RADIX_DECIMAL = 10;
const unsigned char RADIX_HEX = 16;

// Digits used for utoa()
unsigned char DIGITS[] = "0123456789abcdef";

// Subtraction values used for decimal utoa()
unsigned int UTOA10_SUB[] = { 30000, 10000, 3000, 1000, 300, 100, 30, 10 };
// Digit addition values used for decimal utoa()
unsigned char UTOA10_VAL[] = { 3, 1, 3, 1, 3, 1, 3, 1 };

// Decimal utoa() without using multiply or divide
void utoa10w(unsigned int value, unsigned char* dst) {
    unsigned char bStarted = 0;
    unsigned char digit = 0;
    for( unsigned char i: 0..7) {
        while(value>=UTOA10_SUB[i]) { digit += UTOA10_VAL[i]; value -= UTOA10_SUB[i];  bStarted = 1; }
        if((i&1)!=0) {
            if(bStarted!=0) {
                *dst++ = DIGITS[digit];
            }
            digit = 0;
        }
    }
    *dst++ = DIGITS[(unsigned char) value];
    *dst = 0;
}

// Hexadecimal utoa() for an unsigned int (16bits)
void utoa16w(unsigned int value, unsigned char* dst) {
    unsigned char started = 0;
    started = utoa16n(BYTE1(value)>>4, &dst, started);
    started = utoa16n(BYTE1(value)&0x0f, &dst, started);
    started = utoa16n(BYTE0(value)>>4, &dst, started);
    utoa16n(BYTE0(value)&0x0f, &dst, 1);
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