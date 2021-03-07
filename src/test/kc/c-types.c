// Tests the different standard C types

#include <c64-print.h>

void main() {
    print_cls();
    testChar();
    testShort();
    testInt();
    testLong();
}

void testChar() {
    unsigned char u = 14;
    char n = 14;
    signed char s = -14;

    print_str("char: ");
    print_uchar(u);
    print_char(' ');
    print_uchar(n);
    print_char(' ');
    print_schar(s);
    print_ln();

}

void testShort() {
    unsigned short u = 1400;
    short n = -1400;
    signed short s = -1400;

    print_str("short: ");
    print_uint(u);
    print_char(' ');
    print_sint(n);
    print_char(' ');
    print_sint(s);
    print_ln();

}

void testInt() {
    unsigned int u = 1400;
    int n = -1400;
    signed int s = -1400;

    print_str("int: ");
    print_uint(u);
    print_char(' ');
    print_sint(n);
    print_char(' ');
    print_sint(s);
    print_ln();

}

void testLong() {
    unsigned long u = 140000;
    long n = -140000;
    signed long s = -140000;

    print_str("long: ");
    print_ulong(u);
    print_char(' ');
    print_slong(n);
    print_char(' ');
    print_slong(s);
    print_ln();

}
