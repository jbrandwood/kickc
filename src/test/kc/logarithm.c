// Natural logarithm calculation by approximating polynomial
// https://stackoverflow.com/questions/9799041/efficient-implementation-of-natural-logarithm-ln-and-exponentiation
// 1.7417939 + (2.8212026 + (-1.4699568 + (0.44717955 - 0.056570851 * x) * x) * x) * x
// Works well for numbers in the range 1.0 - 2.0
// 0.056570851	463.4284114	463
// 0.44717955	3663.294874	3663
// -1.4699568	-12041.88611	-12042
// 2.8212026	23111.2917	23111
// -1.7417939	-14268.77563	-14269

#include <multiply.h>

void main() {


}


// Calculate natural logarithm for a number between 1.0 and 2.0 using an approximating polynomial
// Uses a number format where the range of signed int [-32768;32768[ represents [-4;4[
void ln_sub(signed int x) {


}