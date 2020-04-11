// An implementation of seriously fast multiply for integer values in the interval [-1;1] with the best possible precision
// NOTE: So far unsuccessful - since the handling of sign and values where a+b>sqrt2) makes the code slower than regular fast multiply
// In this model 255 binary represents 1.0 - meaning that 255*255 = 255
// Uses principles from C=Hacking #16 https://codebase64.org/doku.php?id=magazines:chacking16
// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2

#include <print.h>

void main() {
    print_cls();
    print_str("unsigned");
    print_ln();
    print_mulf8u127(0,0);
    print_mulf8u127(127,127);
    print_mulf8u127(64,64);
    print_mulf8u127(64,127);
    print_mulf8u127(64,192);
    print_mulf8u127(255,127);
    print_mulf8u127(192,192);
    print_mulf8u127(255,255);
    print_str("signed");
    print_ln();
    print_mulf8s127(0,0);
    print_mulf8s127(64,64);
    print_mulf8s127(64,127);
    print_mulf8s127(-64,64);
    print_mulf8s127(64,-64);
    print_mulf8s127(-64,-64);
    print_mulf8s127(127,127);
    print_mulf8s127(-127,127);
    print_mulf8s127(127,-127);
    print_mulf8s127(-127,-127);
}

void print_mulf8u127(unsigned char a, unsigned char b) {
    unsigned word c = mulf8u127(a,b);
    print_byte(a);
    print_char('*');
    print_byte(b);
    print_char('=');
    print_word(c);
    print_ln();
}

void print_mulf8s127(signed char a, signed char b) {
    signed word c = mulf8s127(a,b);
    print_sbyte(a);
    print_char('*');
    print_sbyte(b);
    print_char('=');
    print_sword(c);
    print_ln();
}


// mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
// f(x) = ( x * x )/4
unsigned char align($100) mulf127_sqr1_lo[512] = kickasm{{ .fill 512, <round((i/127*i/127)*127/4) }};
unsigned char align($100) mulf127_sqr1_hi[512] = kickasm{{ .fill 512, >round((i/127*i/127)*127/4) }};
// g(x) =  <((( x - 255) * ( x - 255 ))/4)
unsigned char align($100) mulf127_sqr2_lo[512]  = kickasm{{ .fill 512, <round(((i-255)/127*(i-255)/127)*127/4) }};
unsigned char align($100) mulf127_sqr2_hi[512]  = kickasm{{ .fill 512, >round(((i-255)/127*(i-255)/127)*127/4) }};

unsigned word mulf8u127(unsigned char a, unsigned char b) {
    byte* const memA = $fc;
    byte* const memB = $fd;
    word* const res = $fe;
    byte* const resL = $fe;
    byte* const resH = $ff;
    *memA = a;
    *memB = b;
    asm {
        lda memA
        sta sm1+1
        sta sm3+1
        eor #$ff
        sta sm2+1
        sta sm4+1
        ldx memB
        sec
    sm1:
        lda mulf127_sqr1_lo,x
    sm2:
        sbc mulf127_sqr2_lo,x
        sta resL
    sm3:
        lda mulf127_sqr1_hi,x
    sm4:
        sbc mulf127_sqr2_hi,x
        sta resH
    }
    return *res;
}

signed word mulf8s127(signed char a, signed char b) {
    signed word c = (signed word)mulf8u127((unsigned char)a, (unsigned char)b);
    if(a<0) {
        c -= (signed word)b*2;
    }
    if(b<0) {
        c -= (signed word)a*2;
    }
    if(a<0 && b<0) {
        c -= 0x200;
    }
    return c;
}







