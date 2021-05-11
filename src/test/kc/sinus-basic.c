#include <c64-print.h>
#include <c64-basic-floats.h>

void main() {
    byte f_i[] = {0, 0, 0, 0, 0};
    byte f_127[] = {0, 0, 0, 0, 0};
    byte* const f_2pi = (byte*)$e2e5;
    setFAC(1275);
    divFACby10();
    setMEMtoFAC(f_127);
    for(byte i : 1..25) {
        setFAC((word)i);
        mulFACbyMEM(f_2pi);
        setMEMtoFAC(f_i);
        setFAC(25);
        divMEMbyFAC(f_i);
        sinFAC();
        mulFACbyMEM(f_127);
        addMEMtoFAC(f_127);
        print_uint(getFAC());
        print_ln();
    }
}
