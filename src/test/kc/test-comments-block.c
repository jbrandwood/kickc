/* Tests that block comments are compiled correctly
 * Has a bunch of comments that will be moved into the generated ASM
 */

// The C64 screen
byte* const SCREEN = (char*)$400;

// One of the bytes used for addition
byte a = 'a';

/* The program entry point */
void main() {
    byte i = 0;
    // Do some sums
    for(byte b: 0..10 ) {
        // Output the result on the screen
        SCREEN[i++] = sum(a, b);
    }
}

/** Adds up two bytes and returns the result
 * a - the first byte
 * b - the second byte
 * Returns the sum pf the two bytes
 */
byte sum( byte a, byte b) {
    // calculate the sum
    byte r = a+b;
    // return the sum
    return r;
}