#include <print.h>

byte* RASTER = $d012;
byte* BORDER_COLOR = $d020;
byte* SCREEN = $400;

void main() {
	mulf_init();
	word a = 1234;
	word b = 2345;
    asm { sei }
	while(true) {
	    while(*RASTER!=$ff) {}
	    (*BORDER_COLOR)++;
	    dword r = mulf16u(a, b);
	    (*BORDER_COLOR)--;
	    print_ulong(r);
	    print_set_screen(SCREEN);
	}
}

// Library Implementation of the Seriously Fast Multiplication
// See http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2

// mulf_sqr tables will contain f(x)=int(x*x/4) and g(x) = f(x-255).
// <f(x) = <(( x * x )/4)
byte __align($100) mulf_sqr1_lo[512];
// >f(x) = >(( x * x )/4)
byte __align($100) mulf_sqr1_hi[512];
// <g(x) =  <((( x - 255) * ( x - 255 ))/4)
byte __align($100) mulf_sqr2_lo[512];
// >g(x) = >((( x - 255) * ( x - 255 ))/4)
byte __align($100) mulf_sqr2_hi[512];

// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
void mulf_init() {
  // Fill mulf_sqr1 = f(x) = int(x*x/4): If f(x) = x*x/4 then f(x+1) = f(x) + x/2 + 1/4
  word sqr = 0; // sqr = (x*x)/4
  byte x_2 = 0; // x/2
  byte c = 0;   // Counter used for determining x%2==0
  byte* sqr1_hi = mulf_sqr1_hi+1;
  for(byte* sqr1_lo = mulf_sqr1_lo+1; sqr1_lo!=mulf_sqr1_lo+512; sqr1_lo++) {
    if((++c&1)==0) {
        x_2++; // increase i/2 on even numbers
        sqr++; // sqr++ on even numbers because 1 = 2*1/4 (from the two previous numbers) + 1/2 (half of the previous uneven number)
    }
    *sqr1_lo = <sqr;
    *sqr1_hi++ = >sqr;
    sqr = sqr + x_2; // sqr = sqr + i/2 (when uneven the 1/2 is not added here - see above)
  }
  // Fill mulf_sqr2 = g(x) = f(x-255) : If x-255<0 then g(x)=f(255-x) (because x*x = -x*-x)
  // g(0) = f(255), g(1) = f(254), ..., g(254) = f(1), g(255) = f(0), g(256) = f(1), ..., g(510) = f(255), g(511) = f(256)
  byte x_255 = (byte)-1; //Start with g(0)=f(255)
  byte dir = $ff;  // Decrease or increase x_255 - initially we decrease
  byte* sqr2_hi = mulf_sqr2_hi;
  for(byte* sqr2_lo = mulf_sqr2_lo; sqr2_lo!=mulf_sqr2_lo+511; sqr2_lo++) {
    *sqr2_lo = mulf_sqr1_lo[x_255];
    *sqr2_hi++ = mulf_sqr1_hi[x_255];
    x_255 = x_255 + dir;
    if(x_255==0) {
      dir = 1; // when x_255=0 then start counting up
    }
  }
  // Set the very last value g(511) = f(256)
  *(mulf_sqr2_lo+511) = *(mulf_sqr1_lo+256);
  *(mulf_sqr2_hi+511) = *(mulf_sqr1_hi+256);
}

// Fast multiply two unsigned words to a double word result
// Done in assembler to utilize fast addition A+X
dword mulf16u(word a, word b) {
    word* const memA = $f8;
    word* const memB = $fa;
    dword* const memR = $fc;
    *memA = a;
    *memB = b;
    asm {
        lda memA
        sta sm1a+1
        sta sm3a+1
        sta sm5a+1
        sta sm7a+1
        eor #$ff
        sta sm2a+1
        sta sm4a+1
        sta sm6a+1
        sta sm8a+1
        lda memA+1
        sta sm1b+1
        sta sm3b+1
        sta sm5b+1
        sta sm7b+1
        eor #$ff
        sta sm2b+1
        sta sm4b+1
        sta sm6b+1
        sta sm8b+1
        ldx memB
        sec
sm1a:   lda mulf_sqr1_lo,x
sm2a:   sbc mulf_sqr2_lo,x
        sta memR+0
sm3a:   lda mulf_sqr1_hi,x
sm4a:   sbc mulf_sqr2_hi,x
        sta _AA+1
        sec
sm1b:   lda mulf_sqr1_lo,x
sm2b:   sbc mulf_sqr2_lo,x
        sta _cc+1
sm3b:   lda mulf_sqr1_hi,x
sm4b:   sbc mulf_sqr2_hi,x
        sta _CC+1
        ldx memB+1
        sec
sm5a:   lda mulf_sqr1_lo,x
sm6a:   sbc mulf_sqr2_lo,x
        sta _bb+1
sm7a:   lda mulf_sqr1_hi,x
sm8a:   sbc mulf_sqr2_hi,x
        sta _BB+1
        sec
sm5b:   lda mulf_sqr1_lo,x
sm6b:   sbc mulf_sqr2_lo,x
        sta _dd+1
sm7b:   lda mulf_sqr1_hi,x
sm8b:   sbc mulf_sqr2_hi,x
        sta memR+3
        clc
_AA:    lda #0
_bb:    adc #0
        sta memR+1
_BB:    lda #0
_CC:    adc #0
        sta memR+2
        bcc !+
        inc memR+3
        clc
!:
_cc:    lda #0
        adc memR+1
        sta memR+1
_dd:    lda #0
        adc memR+2
        sta memR+2
        bcc !+
        inc memR+3
!:
    }
    return *memR;
}
