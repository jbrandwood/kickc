// Generates a 16-bit signed sine
#include <sine.h>
#include "sineb.c"
#include <print.h>

void main() {
    word wavelength = 120;
    signed word sintab1[120];
    signed word sintab2[120];
    sin16s_gen(sintab1, wavelength);
    sin16s_genb(sintab2, wavelength);
    print_cls();
    signed word* st1 = sintab1;
    signed word* st2 = sintab2;
    for( byte i: 0..119) {
        signed word sw = *st1 - *st2;
        if(sw>=0) {
          print_str(" ");
        }
        print_sint(sw);
        print_str("   ");
        st1++;
        st2++;
    }
}
