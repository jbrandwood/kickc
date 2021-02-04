// Tests the special "signed" / "unsigned" without a simple type name

#include <c64-print.h>

void main() {
    signed a = -1023;
    unsigned b = 4132;
    for( byte i : 0..5 ) {
        a += -7;
        b += 321;
        print_sint(a);
        print_char(' ');
        print_uint(b);
        print_ln();
    }

}