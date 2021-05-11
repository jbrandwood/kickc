// Test the fast multiplication library
#include <c64-print.h>
#include <multiply.h>
#include <fastmultiply.h>

byte* BG_COLOR = (char*)$d021;

void main() {
    *BG_COLOR = 5;
    print_cls();
    mulf_init();
    mulf_init_asm();
    mulf_tables_cmp();
    mul8u_compare();
    mul8s_compare();
}

// Slow multiplication of unsigned bytes
// Calculate an unsigned multiplication by repeated addition
word muls8u(byte a, byte b) {
    word m = 0;
    if(a!=0) {
        for(byte i = 0; i!=a; i++) {
            m = m + b;
        }
    }
    return m;
}

// Slow multiplication of signed bytes
// Perform a signed multiplication by repeated addition/subtraction
signed word muls8s(signed byte a, signed byte b) {
    signed word m = 0;
    if(a<0) {
        for(signed byte i = 0; i!=a; i--) {
            m = m - b;
        }
    } else if (a>0) {
        for(signed byte j = 0; j!=a; j++) {
            m = m + b;
        }
    }
    return m;
}

// ASM based multiplication tables
// <(( x * x )/4)
byte __align($100) mula_sqr1_lo[512];
// >(( x * x )/4)
byte __align($100) mula_sqr1_hi[512];
// <((( x - 255) * ( x - 255 ))/4)
byte __align($100) mula_sqr2_lo[512];
// >((( x - 255) * ( x - 255 ))/4)
byte __align($100) mula_sqr2_hi[512];
// Initialize the multiplication tables using ASM code from
// http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
void mulf_init_asm() {
    asm{
        ldx #$00
        txa
        .byte $c9
    lb1:
        tya
        adc #$00
    ml1:
        sta mula_sqr1_hi,x
        tay
        cmp #$40
        txa
        ror
    ml9:
        adc #$00
        sta ml9+1
        inx
    ml0:
        sta mula_sqr1_lo,x
        bne lb1
        inc ml0+2
        inc ml1+2
        clc
        iny
        bne lb1
        ldx #$00
        ldy #$ff
    !:
        lda mula_sqr1_hi+1,x
        sta mula_sqr2_hi+$100,x
        lda mula_sqr1_hi,x
        sta mula_sqr2_hi,y
        lda mula_sqr1_lo+1,x
        sta mula_sqr2_lo+$100,x
        lda mula_sqr1_lo,x
        sta mula_sqr2_lo,y
        dey
        inx
        bne !-
    }
    // Ensure the ASM tables are not detected as unused by the optimizer
    byte* mem = (byte*)$ff;
    *mem = *mula_sqr1_lo;
    *mem = *mula_sqr1_hi;
    *mem = *mula_sqr2_lo;
    *mem = *mula_sqr2_hi;
}

// Compare the ASM-based mul tables with the KC-based mul tables
// Red screen on failure - green on success
void mulf_tables_cmp() {
    byte* asm_sqr = mula_sqr1_lo;
    for( byte* kc_sqr=mulf_sqr1_lo; kc_sqr<mulf_sqr1_lo+512*4; kc_sqr++) {
        if(*kc_sqr != *asm_sqr) {
            *BG_COLOR = 2;
            print_str("multiply table mismatch at ");
            print_uint((word)asm_sqr);
            print_str(" / ");
            print_uint((word)kc_sqr);
            return;
        }
        asm_sqr++;
    }
    print_str("multiply tables match!");
    print_ln();
}

// Perform all possible byte multiplications (slow and fast) and compare the results
void mul8u_compare() {
    for(byte a: 0..255) {
        for(byte b: 0..255) {
            word ms = muls8u(a, b);
            word mf = mulf8u(a,b);
            word mn = mul8u(a,b);
            byte ok = 1;
            if(ms!=mf) {
                ok = 0;
            }
            if(ms!=mn) {
                ok = 0;
            }
            if(ok==0) {
                *BG_COLOR = 2;
                mul8u_error(a,b, ms, mn, mf);
                return;
            }
        }
    }
    print_str("multiply results match!");
    print_ln();
}

void mul8u_error(byte a, byte b, word ms, word mn, word mf) {
  print_str("multiply mismatch ");
  print_uchar(a);
  print_str("*");
  print_uchar(b);
  print_str(" slow:");
  print_uint(ms);
  print_str(" / normal:");
  print_uint(mn);
  print_str(" / fast:");
  print_uint(mf);
  print_ln();
}

// Perform all possible signed byte multiplications (slow and fast) and compare the results
void mul8s_compare() {
    for(signed byte a = -128; a!=-128; a++) {
        for(signed byte b = -128; b!=-128; b++) {
            signed word ms = muls8s(a, b);
            signed word mf = mulf8s(a,b);
            signed word mn = mul8s(a,b);
            byte ok = 1;
            if(ms!=mf) {
                ok = 0;
            }
            if(ms!=mn) {
                ok = 0;
            }
            if(ok==0) {
                *BG_COLOR = 2;
                mul8s_error(a,b, ms, mn, mf);
                return;
            }
        }
    }
    print_str("signed multiply results match!");
    print_ln();
}

void mul8s_error(signed byte a, signed byte b, signed word ms, signed word mn, signed word mf) {
  print_str("signed multiply mismatch ");
  print_schar(a);
  print_str("*");
  print_schar(b);
  print_str(" slow:");
  print_sint(ms);
  print_str(" / normal:");
  print_sint(mn);
  print_str(" / fast:");
  print_sint(mf);
  print_ln();
}

