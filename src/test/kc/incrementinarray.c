#include <print.c>

byte txt[] = "camelot";

void main() {
    print_cls();
    for ( byte i: 0..10) {
        print_str(txt);
        print_ln();
        txt[1]++;
    }

}