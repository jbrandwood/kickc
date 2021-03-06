#include <c64.h>
#include <c64-print.h>

word words[] = { $0012, $3f34, $cfed };


void main() {
    print_cls();
    byte s = 0;
    for( byte i: 0..2) {
        word w1 = words[i];
        for( byte j: 0..2) {
            word w2 = words[j];
            for( byte op: 0..5 ) {
                compare(w1,w2,op);
                if(++s==3) {
                    s=0;
                    print_ln();
                }
            }
        }
    }
    // loop forever
    while(true) {}
}

const byte LT = 0;
const byte LE = 1;
const byte GT = 2;
const byte GE = 3;
const byte EQ = 4;
const byte NE = 5;

// empty circle
const byte FF = $57;
// filled circle
const byte TT = $51;

// Compare two words using an operator
void compare(word w1, word w2, byte op) {
    byte r = FF;
    byte* ops;
    if(op==0) {
        // LESS THAN
        if(w1<w2) r = TT;
        ops = "< ";
    } else if(op==1) {
        // LESS THAN EQUAL
        if(w1<=w2) r = TT;
        ops = "<=";
    } else if(op==2) {
        // GREATER THAN
        if(w1>w2) r = TT;
        ops = "> ";
    } else if(op==3) {
        // GREATER THAN EQUAL
        if(w1>=w2) r = TT;
        ops = ">=";
    } else if(op==4) {
        // EQUAL
        if(w1==w2) r = TT;
        ops = "==";
    } else if(op==5) {
        // NOT EQUAL
        if(w1!=w2) r = TT;
        ops = "!=";
    }
    print_uint(w1);
    print_str(ops);
    print_uint(w2);
    print_char(r);
    print_char(' ');
}

