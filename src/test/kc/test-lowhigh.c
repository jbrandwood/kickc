#include <print.c>

void main() {
    print_cls();
    for( dword dw = $12345678; dw != $12345690; dw++ ) {
        dword dw2 = dw;
        >dw2 = (>dw) + $1111;  // Test set/get high word of dword
        <dw2 = (<dw) + $1111;  // Test set/get low word of dword
        print_dword(dw2);
        print_char(' ');
        print_word(>dw2); // Test get high word of dword
        print_char(' ');
        print_word(<dw2); // Test get low word of dword
        print_char(' ');
        print_byte(> >dw2); // Test get high high byte of dword
        print_char(' ');
        print_byte(< >dw2); // Test get low high byte of dword
        print_char(' ');
        print_byte(> <dw2); // Test get high low byte of dword
        print_char(' ');
        print_byte(< <dw2); // Test get low low byte of dword
        print_ln();
    }
}