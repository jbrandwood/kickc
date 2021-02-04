// Test the binary division library
#include <c64-print.h>
#include <division.h>

void main() {
    print_cls();
    test_8u();
    test_16u();
    test_8s();
    test_16s();
}

void test_8u() {
    byte dividends[] = { 255, 255, 255, 255, 255, 255};
    byte divisors[] = { 5, 7, 11, 13, 17, 19 };
    byte rem = 0;
    for( byte i: 0..5 ) {
        byte dividend = dividends[i];
        byte divisor = divisors[i];
        byte res = div8u(dividend, divisor);
        print_uchar(dividend);
        print_str(" / ");
        print_uchar(divisor);
        print_str(" = ");
        print_uchar(res);
        print_str(" ");
        print_uchar(rem8u);
        print_ln();
    }
}

void test_16u() {
    word dividends[] = { $ffff, $ffff, $ffff, $ffff, $ffff, $ffff};
    word divisors[] = { 5, 7, 11, 13, 17, 19 };
    for( byte i : 0..5) {
        word dividend = dividends[i];
        word divisor = divisors[i];
        word res = div16u(dividend, divisor);
        print_uint(dividend);
        print_str(" / ");
        print_uint(divisor);
        print_str(" = ");
        print_uint(res);
        print_str(" ");
        print_uint(rem16u);
        print_ln();
    }
}

void test_8s() {
    signed byte dividends[] = { 127, -127, -127, 127, 127, 127};
    signed byte divisors[] = { 5, 7, -11, -13, 17, 19 };
    for( byte i: 0..5 ) {
        signed byte dividend = dividends[i];
        signed byte divisor = divisors[i];
        signed byte res = div8s(dividend, divisor);
        print_schar(dividend);
        print_str(" / ");
        print_schar(divisor);
        print_str(" = ");
        print_schar(res);
        print_str(" ");
        print_schar(rem8s);
        print_ln();
    }
}

void test_16s() {
    signed word dividends[] = { $7fff, $7fff, -$7fff, -$7fff, $7fff, -$7fff};
    signed word divisors[] = { 5, -7, 11, -13, -17, 19 };
    for( byte i: 0..5) {
        signed word dividend = dividends[i];
        signed word divisor = divisors[i];
        signed word res = div16s(dividend, divisor);
        print_sint(dividend);
        print_str(" / ");
        print_sint(divisor);
        print_str(" = ");
        print_sint(res);
        print_str(" ");
        print_sint(rem16s);
        print_ln();
    }
}
