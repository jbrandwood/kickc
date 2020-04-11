// Table-based implementation of integer square sqr() and square root sqrt()

// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
void init_squares();

// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
word sqr(byte val);

// Find the (integer) square root of a word value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
byte sqrt(word val);
