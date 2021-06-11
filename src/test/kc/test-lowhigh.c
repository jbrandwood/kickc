#include <c64-print.h>

void main() {
    print_cls();
    for( dword dw = $12345678; dw != $12345690; dw++ ) {
        dword dw2 = dw;
        WORD1(dw2) = WORD1(dw) + $1111;  // Test set/get high word of dword
        WORD0(dw2) = WORD0(dw) + $1111;  // Test set/get low word of dword
        print_ulong(dw2);
        print_char(' ');
        print_uint(WORD1(dw2)); // Test get high word of dword
        print_char(' ');
        print_uint(WORD0(dw2)); // Test get low word of dword
        print_char(' ');
        print_uchar(BYTE3(dw2)); // Test get high high byte of dword
        print_char(' ');
        print_uchar(BYTE2(dw2)); // Test get low high byte of dword
        print_char(' ');
        print_uchar(BYTE1(dw2)); // Test get high low byte of dword
        print_char(' ');
        print_uchar(BYTE0(dw2)); // Test get low low byte of dword
        print_ln();
    }
}