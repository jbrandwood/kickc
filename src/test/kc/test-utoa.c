// Tests the utoa10() function that converts unsigned int to DECIMAL string
#include <stdlib.c>
#include <print.c>

// buffer for number
char buf[17];

void main() {
    print_cls();
    print_utoas(0xffff);
    print_utoas(59999);
    print_utoas(0xaaaa);
    print_utoas(0x5555);
    print_utoas(9999);
    print_utoas(0x0fff);
    print_utoas(999);
    print_utoas(0x0ff);
    print_utoas(99);
    print_utoas(0x0f);
    print_utoas(1);
    utoa(1, buf, 10);
    print_str(buf);
    print_ln();
}

void print_utoas(unsigned int value) {
    utoa(value, buf, HEXADECIMAL);
    print_str(buf);
    print_char(' ');
    utoa(value, buf, DECIMAL);
    print_str(buf);
    print_char(' ');
    utoa(value, buf, OCTAL);
    print_str(buf);
    print_char(' ');
    utoa(value, buf, BINARY);
    print_str(buf);
    print_ln();
}