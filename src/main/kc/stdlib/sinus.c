// Sinus Generator functions using only multiplication, addition and bit shifting
// Uses a single division for converting the wavelength to a reciprocal.
// Generates sinus using the series sin(x) = x - x^/3! + x^-5! - x^7/7! ...
// Uses the approximation sin(x) = x - x^/6 + x^/128
// Optimization possibility: Use symmetries when generating sinustables. wavelength%2==0 -> mirror symmetry over PI, wavelength%4==0 -> mirror symmetry over PI/2.

#include <division.c>
#include <multiply.c>

// PI*2 in u[4.28] format
const dword PI2_u4f28 = $6487ed51;
// PI in u[4.28] format
const dword PI_u4f28 = $3243f6a9;
// PI/2 in u[4.28] format
const dword PI_HALF_u4f28 = $1921FB54;

// PI*2 in u[4.12] format
const word PI2_u4f12 = $6488;
// PI in u[4.12] format
const word PI_u4f12 = $3244;
// PI/2 in u[4.12] format
const word PI_HALF_u4f12 = $1922;

// Generate signed (large) word sinus table - on the full -$7fff - $7fff range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
void sin16s_gen(signed word* sintab, word wavelength) {
    // u[4.28] step = PI*2/wavelength
    dword step = div32u16u(PI2_u4f28, wavelength); // u[4.28]
    // Iterate over the table
    dword x = 0; // u[4.28]
    for( word i=0; i<wavelength; i++) {
        *sintab++ = sin16s(x);
        x = x + step;
    }
}

// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
void sin16s_gen2(signed word* sintab, word wavelength, signed word min, signed word max) {
    signed word ampl = max-min;
    signed word offs = min + ampl>>1; // ampl is always positive so shifting left does not alter the sign
    // u[4.28] step = PI*2/wavelength
    dword step = div32u16u(PI2_u4f28, wavelength); // u[4.28]
    // Iterate over the table
    dword x = 0; // u[4.28]
    for( word i=0; i<wavelength; i++) {
        *sintab++ = offs + (signed word)>mul16s(sin16s(x), ampl); // The signed sin() has values [-7fff;7fff] = [-1/2 ; 1/2], so ampl*sin has the right amplitude
        x = x + step;
    }
}

// Generate signed byte sinus table - on the full -$7f - $7f range
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
void sin8s_gen(signed byte* sintab, word wavelength) {
    // u[4.28] step = PI*2/wavelength
    word step = div16u(PI2_u4f12, wavelength); // u[4.12]
    // Iterate over the table
    word x = 0; // u[4.12]
    for( word i=0; i<wavelength; i++) {
        *sintab++ = sin8s(x);
        x = x + step;
    }
}

// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
signed word sin16s(dword x) {
    // Move x1 into the range 0-PI/2 using sinus mirror symmetries
    byte isUpper = 0;
    if(x >= PI_u4f28 ) {
        x = x - PI_u4f28;
        isUpper = 1;
    }
    if(x >= PI_HALF_u4f28 ) {
        x = PI_u4f28 - x;
    }
    // sinx = x - x^3/6 + x5/128;
    word x1 = >x<<3; // u[1.15]
    word x2 = mulu16_sel(x1, x1, 0); // u[2.14] x^2
    word x3 = mulu16_sel(x2, x1, 1); // u[2.14] x^3
    word x3_6 = mulu16_sel(x3, $10000/6, 1);  // u[1.15] x^3/6;
    word usinx = x1 - x3_6; // u[1.15] x - x^3/6
    word x4 = mulu16_sel(x3, x1, 0); // u[3.13] x^4
    word x5 = mulu16_sel(x4, x1, 0); // u[4.12] x^5
    word x5_128 = x5>>4; // // u[1.15] x^5/128 -- much more efficient than mul_u16_sel(x5, $10000/128, 3);
    usinx = usinx + x5_128; // u[1.15] (first bit is always zero)
    signed word sinx = (signed word)usinx; // s[0.15]
    if(isUpper!=0) {
        sinx = -(signed word)usinx; // s[0.15];
     }
     return sinx;
}

// Calculate signed byte sinus sin(x)
// x: unsigned word input u[4.12] in the interval $0000 - PI2_u4f12
// result: signed byte sin(x) s[0.7] - using the full range  -$7f - $7f
signed byte sin8s(word x) {
    // Move x1 into the range 0-PI/2 using sinus mirror symmetries
    byte isUpper = 0;
    if(x >= PI_u4f12 ) {
        x = x - PI_u4f12;
        isUpper = 1;
    }
    if(x >= PI_HALF_u4f12 ) {
        x = PI_u4f12 - x;
    }
    // sinx = x - x^3/6 + x5/128;
    byte x1 = >x<<3; // u[1.7]
    byte x2 = mulu8_sel(x1, x1, 0); // u[2.6] x^2
    byte x3 = mulu8_sel(x2, x1, 1); // u[2.6] x^3
    const byte DIV_6 = $2b; // u[0.7] - $2a.aa rounded to $2b
    byte x3_6 = mulu8_sel(x3, DIV_6, 1);  // u[1.7] x^3/6;
    byte usinx = x1 - x3_6; // u[1.7] x - x^3/6
    byte x4 = mulu8_sel(x3, x1, 0); // u[3.5] x^4
    byte x5 = mulu8_sel(x4, x1, 0); // u[4.4] x^5
    byte x5_128 = x5>>4; // // u[1.7] x^5/128 -- much more efficient than mul_u16_sel(x5, $10000/128, 3);
    usinx = usinx + x5_128; // u[1.7] (first bit is always zero)
    if(usinx>=128) { usinx--; } // rounding may occasionally result in $80 - lower into range ($00-$7f)
    signed byte sinx = (signed byte)usinx; // s[0.7]
    if(isUpper!=0) {
        sinx = -(signed byte)usinx; // s[0.7];
    }
    return sinx;
}

// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
word mulu16_sel(word v1, word v2, byte select) {
    return >mul16u(v1, v2)<<select;
}

// Calculate val*val for two unsigned byte values - the result is 8 selected bits of the 16-bit result.
// The select parameter indicates how many of the highest bits of the 16-bit result to skip
byte mulu8_sel(byte v1, byte v2, byte select) {
    return >mul8u(v1, v2)<<select;
}
