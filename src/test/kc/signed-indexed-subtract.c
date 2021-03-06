// Tests that signed indexed subtract works as intended

#include <c64-print.h>

signed word words[] = {-$6000, -$600, -$60, -6, 0, 6, $60, $600, $6000};

void main() {

    for(byte i: 0..8) {
        sub(i, $80);
        sub(i, $40);
        sub(i, $40);
    }
    print_cls();
    for(byte j: 0..8) {
        print_sint(words[j]);
        print_ln();
    }

}

void sub(byte idx, byte s) {
    words[idx] -= s;
}