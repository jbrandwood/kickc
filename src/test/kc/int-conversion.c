// Tests different integer literal types

const byte RED = 2ub;
const byte GREEN = 5ub;

byte* const SCREEN = (byte*)$400;
byte* const COLS = (char*)$d800;
byte idx = 0ub;

void main() {
    for(byte* s=SCREEN;s<SCREEN+1000;s++) *s = ' ';
    testUnaryOperator();
    testBinaryOperator();
}

void testUnaryOperator() {
    idx = 00;
    // Unary Operations
    assertType(typeid(-12ub), typeid(unsigned byte));
    assertType(typeid(-12sb), typeid(signed byte));
    assertType(typeid(-12uw), typeid(unsigned word));
    assertType(typeid(-12sw), typeid(signed word));
    assertType(typeid(-12ud), typeid(unsigned dword));
    assertType(typeid(-12sd), typeid(signed dword));
}

void testBinaryOperator() {
    idx = 40;
    // Binary Operations between unsigned byte & other types
    assertType(typeid(12ub+12ub), typeid(unsigned byte));
    assertType(typeid(12ub+12sb), typeid(unsigned byte));
    assertType(typeid(12ub+12uw), typeid(unsigned word));
    assertType(typeid(12ub+12sw), typeid(signed word));
    assertType(typeid(12ub+12ud), typeid(unsigned dword));
    assertType(typeid(12ub+12sd), typeid(signed dword));
    idx++;
    // Binary Operations between signed byte & other types
    assertType(typeid(12sb+12ub), typeid(unsigned byte));
    assertType(typeid(12sb+12sb), typeid(signed byte));
    assertType(typeid(12sb+12uw), typeid(unsigned word));
    assertType(typeid(12sb+12sw), typeid(signed word));
    assertType(typeid(12sb+12ud), typeid(unsigned dword));
    assertType(typeid(12sb+12sd), typeid(signed dword));
    idx++;
    // Binary Operations between unsigned word & other types
    assertType(typeid(12uw+12ub), typeid(unsigned word));
    assertType(typeid(12uw+12sb), typeid(unsigned word));
    assertType(typeid(12uw+12uw), typeid(unsigned word));
    assertType(typeid(12uw+12sw), typeid(unsigned word));
    assertType(typeid(12uw+12ud), typeid(unsigned dword));
    assertType(typeid(12uw+12sd), typeid(signed dword));
    idx = 80ub;
    // Binary Operations between signed word & other types
    assertType(typeid(12sw+12ub), typeid(signed word));
    assertType(typeid(12sw+12sb), typeid(signed word));
    assertType(typeid(12sw+12uw), typeid(unsigned word));
    assertType(typeid(12sw+12sw), typeid(signed word));
    assertType(typeid(12sw+12ud), typeid(unsigned dword));
    assertType(typeid(12sw+12sd), typeid(signed dword));
    idx++;
    // Binary Operations between unsigned dword & other types
    assertType(typeid(12ud+12ub), typeid(unsigned dword));
    assertType(typeid(12ud+12sb), typeid(unsigned dword));
    assertType(typeid(12ud+12uw), typeid(unsigned dword));
    assertType(typeid(12ud+12sw), typeid(unsigned dword));
    assertType(typeid(12ud+12ud), typeid(unsigned dword));
    assertType(typeid(12ud+12sd), typeid(unsigned dword));
    idx++;
    // Binary Operations between signed dword & other types
    assertType(typeid(12sd+12ub), typeid(signed dword));
    assertType(typeid(12sd+12sb), typeid(signed dword));
    assertType(typeid(12sd+12uw), typeid(signed dword));
    assertType(typeid(12sd+12sw), typeid(signed dword));
    assertType(typeid(12sd+12ud), typeid(unsigned dword));
    assertType(typeid(12sd+12sd), typeid(signed dword));
}



// Check that the two passed type IDs are equal.
// Shows a letter symbolizing t1
// If they are equal the letter is green - if not it is red.
void assertType(byte t1, byte t2) {
    if(t1==t2) {
        COLS[idx] = GREEN;
    } else {
        COLS[idx] = RED;
    }
    SCREEN[idx++] = t1;
}