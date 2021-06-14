// Sine Generator functions using only multiplication, addition and bit shifting
// Uses a single division for converting the wavelength to a reciprocal.
// Generates sine using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
// Uses the approximation sin(x) = x - x^/6 + x^/128
// Optimization possibility: Use symmetries when generating sine tables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.

#include <sine.h>

// Generate signed (large) word sine table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
void sin16s_genb(signed word* sintab, word wavelength) {
    // u[4.28] step = PI*2/wavelength
    dword step = div32u16u(PI2_u4f28, wavelength); // u[4.28]
    // Iterate over the table
    dword x = 0; // u[4.28]
    for( word i=0; i<wavelength; i++) {
        *sintab++ = sin16sb(WORD1(x));
        x = x + step;
    }
}

// Calculate signed word sine sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
signed word sin16sb(word x) {
    // Move x1 into the range 0-PI/2 using sine mirror symmetries
    byte isUpper = 0;
    if(x >= PI_u4f12 ) {
        x = x - PI_u4f12;
        isUpper = 1;
    }
    if(x >= PI_HALF_u4f12 ) {
        x = PI_u4f12 - x;
    }
    // sinx = x - x^3/6 + x5/128;
    word x1 = x*8; // u[1.15]
    word x2 = mulu16_sel(x1, x1, 0); // u[2.14] x^2
    word x3 = mulu16_sel(x2, x1, 1); // u[2.14] x^3
    word x3_6 = mulu16_sel(x3, $10000/6, 1);  // u[1.15] x^3/6;
    word usinx = x1 - x3_6; // u[1.15] x - x^3/6
    word x4 = mulu16_sel(x3, x1, 0); // u[3.13] x^4
    word x5 = mulu16_sel(x4, x1, 0); // u[4.12] x^5
    word x5_128 = x5/$10; // // u[1.15] x^5/128 -- much more efficient than mul_u16_sel(x5, $10000/128, 3);
    usinx = usinx + x5_128; // u[1.15] (first bit is always zero)
    signed word sinx = (signed word)usinx; // s[0.15]
    if(isUpper!=0) {
        sinx = -(signed word)usinx; // s[0.15];
     }
     return sinx;
}
