/**
 * @file checksum.c
 * @brief Helper functions for calculating IP checksums.
 * @compiler CPIK 0.7.3 / MCC18 3.36
 * @author Bruno Basseto (bruno@wise-ware.org)
 */

/********************************************************************************
 ********************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 1995-2013 Bruno Basseto (bruno@wise-ware.org).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ********************************************************************************
 ********************************************************************************/

#define HIGH(w) BYTE1(w)
#define LOW(w) BYTE0(w)
#define uint16_t unsigned short
#define int32_t long int
#define int16_t short int
#define int8_t signed char
#define uint8_t unsigned char
#define byte_t unsigned char

typedef union {
   uint16_t u;
   byte_t b[2];
} chks_t;

extern chks_t chks;

extern void add_checksum(uint16_t v);
#define checksum_init() {chks.u = 0;}
#define checksum_result() (~chks.u)

/**
 * Last checksum computation result.
 */
chks_t chks;

static byte_t _a, _b, _c;
static unsigned int _b16;

/**
 * Sums a 16-bit word to the current checksum value.
 * Optimized for 8-bit word processors.
 * The result is found in chks.
 * @param v Value to sum.
 */
void
add_checksum
   (uint16_t v)
{
   /*
    * First byte (MSB).
    */
   _a = chks.b[0];
   _b16 = (uint16_t)_a + HIGH(v);
   _b = LOW(_b16);
   _c = HIGH(_b16 >> 8);
   chks.b[0] = _b;

   /*
    * Second byte (LSB).
    */
   _a = chks.b[1];
   _b16 = (uint16_t)_a + (LOW(v)) + _c;;
   _b = LOW(_b16);
   _c = HIGH(_b16);
   chks.b[1] = _b;

   /*
    * Test for carry.
    */
   if(_c) {
      if(++chks.b[0] == 0) chks.b[1]++;
   }
}

unsigned int * const SCREEN = (unsigned int *)0x0400;

void main() {
    checksum_init();
    add_checksum(0x1234);
    SCREEN[0] = chks.u;
    add_checksum(0x2345);
    SCREEN[1] = chks.u;
    add_checksum(0x3456);
    SCREEN[1] = chks.u;
}