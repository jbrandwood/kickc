// Test the fast multiplication library
#include <print.h>
#include <multiply.h>
#include <fastmultiply.h>

byte* BGCOL = $d021;

void main() {
    *BGCOL = 5;
    print_cls();
    mulf_init();
    mul16u_compare();
    mul16s_compare();
}

// Slow multiplication of unsigned words
// Calculate an unsigned multiplication by repeated addition
dword muls16u(word a, word b) {
    dword m = 0;
    if(a!=0) {
        for(word i = 0; i!=a; i++) {
            m = m + b;
        }
    }
    return m;
}

// Slow multiplication of signed words
// Perform a signed multiplication by repeated addition/subtraction
signed dword muls16s(signed word a, signed word b) {
    signed dword m = 0;
    if(a<0) {
        for(signed word i = 0; i!=a; i--) {
            m = m - b;
        }
    } else if (a>0) {
        for(signed word j = 0; j!=a; j++) {
            m = m + b;
        }
    }
    return m;
}

// Perform many possible word multiplications (slow and fast) and compare the results
void mul16u_compare() {
    word a = 0;
    word b = 0;
    for(byte i: 0..15) {
        print_str(".");
        for(byte j: 0..15) {
            a=a+3371;
            b=b+4093;
            dword ms = muls16u(a, b);
            dword mn = mul16u(a,b);
            dword mf = mulf16u(a,b);
            byte ok = 1;
            if(ms!=mf) {
                ok = 0;
            }
            if(ms!=mn) {
                ok = 0;
            }
            if(ok==0) {
                *BGCOL = 2;
                mul16u_error(a,b, ms, mn, mf);
                return;
            }
        }
    }
    print_ln();
    print_str("word multiply results match!");
    print_ln();
}

void mul16u_error(word a, word b, dword ms, dword mn, dword mf) {
  print_str("multiply mismatch ");
  print_uint(a);
  print_str("*");
  print_uint(b);
  print_str(" slow:");
  print_ulong(ms);
  print_str(" / normal:");
  print_ulong(mn);
  print_str(" / fast:");
  print_ulong(mf);
  print_ln();
}

// Perform many possible word multiplications (slow and fast) and compare the results
void mul16s_compare() {
    signed word a = -$7fff;
    signed word b = -$7fff;
    for(byte i: 0..15) {
        print_str(".");
        for(byte j: 0..15) {
            a=a+3371;
            b=b+4093;
            signed dword ms = muls16s(a, b);
            signed dword mn = mul16s(a,b);
            signed dword mf = mulf16s(a,b);
            byte ok = 1;
            if(ms!=mf) {
                ok = 0;
            }
            if(ms!=mn) {
                ok = 0;
            }
            if(ok==0) {
                *BGCOL = 2;
                mul16s_error(a,b, ms, mn, mf);
                return;
            }
        }
    }
    print_ln();
    print_str("signed word multiply results match!");
    print_ln();
}

void mul16s_error(signed word a, signed word b, signed dword ms, signed dword mn, signed dword mf) {
  print_str("signed word multiply mismatch ");
  print_sint(a);
  print_str("*");
  print_sint(b);
  print_str(" slow:");
  print_slong(ms);
  print_str(" / normal:");
  print_slong(mn);
  print_str(" / fast:");
  print_slong(mf);
  print_ln();
}
