// LongLong implementation supporting integer addition and multiplication for 64bit signed integers

#include <stdlib.h>

struct LongLong {
    // The lower 32bit
    long low;
    // The upper 32bit
    long high;
};

// Creates a LongLong for a signed long value
struct LongLong toLongLong(long l) {
    if(l<0)
        return {l,-1l};
    else
        return {l,0l};
}

// Add two LongLongs together
struct LongLong plusLongLong(__ma struct LongLong a, __ma struct LongLong b) {
    __ma struct LongLong sum;
    asm {
        clc
        lda a
        adc b
        sta sum
        lda a+1
        adc b+1
        sta sum+1
        lda a+2
        adc b+2
        sta sum+2
        lda a+3
        adc b+3
        sta sum+3
        lda a+4
        adc b+4
        sta sum+4
        lda a+5
        adc b+5
        sta sum+5
        lda a+6
        adc b+6
        sta sum+6
        lda a+7
        adc b+7
        sta sum+7
    }
    return sum;
}



struct LongLong * SCREEN = (char*)0x0400;

void main() {
    struct LongLong a = toLongLong(1000);
    struct LongLong b = toLongLong(-2000);
    struct LongLong c = plusLongLong(a,b);
    SCREEN[0] = a;
    SCREEN[2] = b;
    SCREEN[4] = c;
}


