// Test the binary division library
#include <print.c>
#include <division.c>

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
        print_byte(dividend);
        print_str(" / ");
        print_byte(divisor);
        print_str(" = ");
        print_byte(res);
        print_str(" ");
        print_byte(rem8u);
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
        print_word(dividend);
        print_str(" / ");
        print_word(divisor);
        print_str(" = ");
        print_word(res);
        print_str(" ");
        print_word(rem16u);
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
        print_sbyte(dividend);
        print_str(" / ");
        print_sbyte(divisor);
        print_str(" = ");
        print_sbyte(res);
        print_str(" ");
        print_sbyte(rem8s);
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
        print_sword(dividend);
        print_str(" / ");
        print_sword(divisor);
        print_str(" = ");
        print_sword(res);
        print_str(" ");
        print_sword(rem16s);
        print_ln();
    }
}