#include <c64-print.h>

byte txt[] = "camelot";

void main() {
    print_cls();
    for ( byte i: 0..10) {
        print_str(txt);
        print_ln();
        txt[1]++;
    }

}