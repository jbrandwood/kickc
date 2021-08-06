// Test declarations of variables without definition

/// Unsigned integer type with a width of exactly 16 bits
typedef unsigned int uint16_t;
/// Unsigned integer type with a width of exactly 32 bits
typedef unsigned long uint32_t;

#define byte_t unsigned char

typedef union {
   uint32_t d;
   uint16_t w[2];
   byte_t b[4];
} _uint32_t;

// A volatile extern
extern volatile _uint32_t ticks;

// The actual declarations
volatile _uint32_t ticks;

// And a little code using them
void main() {
    _uint32_t * SCREEN = (_uint32_t*)0x0400;
    *SCREEN = ticks;
    
}







