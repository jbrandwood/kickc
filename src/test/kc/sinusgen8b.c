#include <sinus.h>
#include <print.h>

void main() {
    word wavelength = 192;
    signed byte sintabb[192];
    sin8s_gen(sintabb, wavelength);
    signed word sintabw[192];
    sin16s_gen(sintabw, wavelength);
    print_cls();
    for(byte i: 0..191) {
        signed byte sb = sintabb[i];
        signed word sw = *(sintabw+(word)i);
        signed byte sd = sb-(signed byte)>sw;
        print_schar(sd);
        print_str("  ");
    }
}
