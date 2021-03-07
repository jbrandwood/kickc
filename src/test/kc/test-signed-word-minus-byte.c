// Tests subtracting bytes from signed words

#include <c64-print.h>

void main() {
    signed word w1 = 1234;

    print_cls();
    for( byte i: 0..10 ) {
        signed word w2 = w1 - 91;
        w1 = w2 - 41;
        print_sint(w1);
        print_char(' ');
        print_sint(w2);
        print_ln();
    }


}