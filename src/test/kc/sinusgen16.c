// Generates a 16-bit signed sinus
#include <sinus.c>
#include <print.c>

void main() {
    word wavelength = 120;
    signed word sintab1[120];
    sin16s_gen(sintab1, wavelength);
    print_cls();
    for(signed word* st1 = sintab1; st1<sintab1+wavelength; st1++ ) {
        signed word sw = *st1;
        if(sw>=0) {
          print_str(" ");
        }
        print_sword(sw);
        print_str("   ");
    }
}
