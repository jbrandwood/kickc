#include <sinus.c>
#include <multiply.c>
#include <print.c>

void main() {
    word tabsize = 20;
    byte sintab[20];
    print_cls();
    sin8u_table(sintab, tabsize, 10, 255);
    /*
    print_cls();
    for(byte i: 0..191) {
        signed byte sb = sintab[i];
        if(sb>=0) {
          print_str(" ");
        }
        print_sbyte(sb);
        print_str("  ");
    }
    */
}

// Generate unsigned byte sinus table in a min-max range
// sintab - the table to generate into
// tabsize - the number of sinus points (the size of the table)
// min - the minimal value
// max - the maximal value
void sin8u_table(byte* sintab, word tabsize, byte min, byte max) {
    byte amplitude = max-min;
    word sum = (word)min+max;
    byte mid = (byte)((sum/2)+1);
    //if( sum & 1 > 0) mid++;
    // u[4.28] step = PI*2/wavelength
    word step = div16u(PI2_u4f12, tabsize); // u[4.12]
    print_str("step:");
    print_word(step);
    print_str(" min:");
    print_byte(min);
    print_str(" max:");
    print_byte(max);
    print_str(" ampl:");
    print_byte(amplitude);
    print_str(" mid:");
    print_byte(mid);
    print_ln();
    // Iterate over the table
    word x = 0; // u[4.12]
    for( word i=0; i<tabsize; i++) {
        signed byte sinx = sin8s(x);
        signed word sinx_sc = mul8su(sinx, amplitude+1);
        byte sinx_tr = mid+>sinx_sc;
        *sintab++ = sinx_tr;
        print_str("x: ");
        print_word(x);
        print_str(" sin: ");
        print_sbyte(sinx);
        print_str(" scaled: ");
        print_sword(sinx_sc);
        print_str(" trans: ");
        print_byte(sinx_tr);
        print_ln();
        x = x + step;
    }
}
