// Tests conversion of numbers to correct int types
// See https://gitlab.com/camelot/kickc/issues/181

void main() {

    // Signed type and number
    // a) If one operand is a signed type and the other a number.
    //    The number becomes the smallest signed type that can hold its value (if one exists).
    //    The two operands are then converted normally (using 2a or 2b).
    idx = 0ub;
    assertType(typeid(12sb+12), typeid(signed byte));
    assertType(typeid(12sb+130), typeid(signed word));
    assertType(typeid(12sb+33000), typeid(signed dword));
    assertType(typeid(12sw+12), typeid(signed word));
    assertType(typeid(12sw+130), typeid(signed word));
    assertType(typeid(12sw+100000), typeid(signed dword));
    assertType(typeid(12sd+12), typeid(signed dword));
    assertType(typeid(12sd+130), typeid(signed dword));
    assertType(typeid(12sd+100000), typeid(signed dword));

    // Unsigned type and positive number
    // b) If one operand is an unsigned type and the other a positive number.
    //    The number is converted to the smallest unsigned type that can hold the value.
    //    The two operands are then converted normally (using 2a or 2b).
    idx = 40ub;
    assertType(typeid(12ub+12), typeid(unsigned byte));
    assertType(typeid(12ub+250), typeid(unsigned byte));
    assertType(typeid(12ub+300), typeid(unsigned word));
    assertType(typeid(12ub+65534), typeid(unsigned word));
    assertType(typeid(12ub+66000), typeid(unsigned dword));
    assertType(typeid(12uw+12), typeid(unsigned word));
    assertType(typeid(12uw+130), typeid(unsigned word));
    assertType(typeid(12uw+66000), typeid(unsigned dword));
    assertType(typeid(12ud+12), typeid(unsigned dword));
    assertType(typeid(12ud+130), typeid(unsigned dword));
    assertType(typeid(12ud+66000), typeid(unsigned dword));
    assertType(typeid(12ub+3000000000), typeid(unsigned dword));

    // Unsigned type and negative number
    // If one operand is an unsigned type and the other a negative number.
    // The number is first converted to the smallest signed type that can hold its value (if one exits).
    // If the signed type is smaller than the unsigned type it is converted up to the size of the unsigned type.
    // The signed type is finally converted to unsigned.
    // The two unsigned operands are then finally converted to the size of the largest type (using 2b).
    idx = 80ub;
    assertType(typeid(12ub+-12), typeid(unsigned byte));
    assertType(typeid(12ub+-120), typeid(unsigned byte));
    assertType(typeid(12ub+-250), typeid(unsigned byte));
    assertType(typeid(12ub+-260), typeid(unsigned word));
    assertType(typeid(12ub+-65000), typeid(unsigned word));
    assertType(typeid(12ub+-66000), typeid(unsigned dword));
    assertType(typeid(12uw+-12), typeid(unsigned word));
    assertType(typeid(12uw+-130), typeid(unsigned word));
    assertType(typeid(12uw+-65000), typeid(unsigned word));
    assertType(typeid(12uw+-66000), typeid(unsigned dword));
    assertType(typeid(12ud+-12), typeid(unsigned dword));
    assertType(typeid(12ud+-130), typeid(unsigned dword));
    assertType(typeid(12ud+-66000), typeid(unsigned dword));
    assertType(typeid(12sb+-2100000000), typeid(unsigned dword));


}




const byte RED = 2ub;
const byte GREEN = 5ub;

byte* const SCREEN = $0400uw;
byte* const COLS = $d800uw;
byte idx = 0ub;

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