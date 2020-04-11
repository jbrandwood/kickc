// Table-based implementation of integer square sqr() and square root sqrt()

#include <sqr.h>
#include <stdlib.h>

// The number of squares to pre-calculate. Limits what values sqr() can calculate and the result of sqrt()
byte NUM_SQUARES = 0xff;

// Squares for each byte value SQUARES[i] = i*i
// Initialized by init_squares()
word* SQUARES;

// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
void init_squares() {
    SQUARES = malloc(NUM_SQUARES*sizeof(word));
    word* squares = SQUARES;
    word sqr = 0;
    for(byte i=0;i<NUM_SQUARES;i++) {
        *squares++ = sqr;
        sqr += i*2+1;
    }
}

// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
word sqr(byte val) {
    return SQUARES[val];
}

// Find the (integer) square root of a word value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
byte sqrt(word val) {
    word* found = bsearch16u(val, SQUARES, NUM_SQUARES);
    byte sq = (byte)(found-SQUARES);
    return sq;
}
