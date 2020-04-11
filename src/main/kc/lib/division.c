// Simple binary division implementation
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5

#include <division.h>

// Remainder after signed 8 bit division
byte rem8u =0;

// Performs division on two 8 bit unsigned bytes
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8u
// Implemented using simple binary division
byte div8u(byte dividend, byte divisor) {
    return divr8u(dividend, divisor, 0);
}

// Performs division on two 8 bit unsigned bytes and an initial remainder
// Returns dividend/divisor.
// The final remainder will be set into the global variable rem8u
// Implemented using simple binary division
byte divr8u(byte dividend, byte divisor, byte rem) {
    byte quotient = 0;
    for( byte i : 0..7) {
        rem = rem << 1;
        if( (dividend & $80) != 0 ) {
            rem = rem | 1;
        }
        dividend = dividend << 1;
        quotient = quotient << 1;
        if(rem>=divisor) {
            quotient++;
            rem = rem - divisor;
        }
    }
    rem8u = rem;
    return quotient;
}

// Remainder after unsigned 16-bit division
word rem16u = 0;

// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
word divr16u(word dividend, word divisor, word rem) {
    word quotient = 0;
    for( byte i : 0..15) {
        rem = rem << 1;
        if( (>dividend & $80) != 0 ) {
            rem = rem | 1;
        }
        dividend = dividend << 1;
        quotient = quotient << 1;
        if(rem>=divisor) {
            quotient++;
            rem = rem - divisor;
        }
    }
    rem16u = rem;
    return quotient;
}

// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
word div16u(word dividend, word divisor) {
    return divr16u(dividend, divisor, 0);
}

// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
dword div32u16u(dword dividend, word divisor) {
  word quotient_hi = divr16u(>dividend, divisor, 0);
  word quotient_lo = divr16u(<dividend, divisor, rem16u);
  dword quotient = { quotient_hi, quotient_lo};
  return quotient;
}

// Remainder after signed 8 bit division
signed byte rem8s = 0;

// Perform division on two signed 8-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem8s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed byte div8s(signed byte dividend, signed byte divisor) {
    byte neg = 0;
    byte dividendu = 0;
    if(dividend<0) {
      dividendu = (byte)-dividend;
      neg = 1;
    } else {
      dividendu = (byte)dividend;
    }
    byte divisoru = 0;
    if(divisor<0) {
        divisoru = (byte)-divisor;
        neg = neg ^ 1;
    } else {
        divisoru = (byte)divisor;
    }
    byte resultu = div8u(dividendu, divisoru);
    if(neg==0) {
        rem8s = (signed byte)rem8u;
        return (signed byte)resultu;
    } else {
        rem8s = -(signed byte)rem8u;
        return -(signed byte)resultu;
    }
}

// Remainder after signed 16 bit division
signed word rem16s = 0;

// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed word divr16s(signed word dividend, signed word divisor, signed word rem) {
    byte neg = 0;
    word dividendu = 0;
    word remu = 0;
    if(dividend<0 || rem<0) {
      dividendu = (word)-dividend;
      remu = (word)-rem;
      neg = 1;
    } else {
      dividendu = (word)dividend;
      remu = (word)rem;
    }
    word divisoru = 0;
    if(divisor<0) {
        divisoru = (word)-divisor;
        neg = neg ^ 1;
    } else {
        divisoru = (word)divisor;
    }
    word resultu = divr16u(dividendu, divisoru, remu);
    if(neg==0) {
        rem16s = (signed word)rem16u;
        return (signed word)resultu;
    } else {
        rem16s = -(signed word)rem16u;
        return -(signed word)resultu;
    }
}

// Perform division on two signed 16-bit numbers
// Returns dividend/divisor.
// The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
signed word div16s(signed word dividend, signed word divisor) {
    return divr16s(dividend, divisor, 0);
}
