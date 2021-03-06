// Test signed word comparisons

#include <c64.h>
#include <c64-print.h>

signed word swords[] = { -$6fed, $0012, $7fed };


void main() {
    print_cls();
    byte s = 0;
    for( byte i: 0..2) {
        signed word w1 = swords[i];
        for( byte j: 0..2) {
            signed word w2 = swords[j];
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
void compare(signed word w1, signed word w2, byte op) {
    byte r = FF;
    byte* ops;
    if(op==LT) {
        // LESS THAN
        if(w1<w2) r = TT;
        ops = "< ";
    } else if(op==LE) {
        // LESS THAN EQUAL
        if(w1<=w2) r = TT;
        ops = "<=";
    } else if(op==GT) {
        // GREATER THAN
        if(w1>w2) r = TT;
        ops = "> ";
    } else if(op==GE) {
        // GREATER THAN EQUAL
        if(w1>=w2) r = TT;
        ops = ">=";
    } else if(op==EQ) {
        // EQUAL
        if(w1==w2) r = TT;
        ops = "==";
    } else if(op==NE) {
        // NOT EQUAL
        if(w1!=w2) r = TT;
        ops = "!=";
    }
    print_sint(w1);
    print_str(ops);
    print_sint(w2);
    print_char(r);
}

