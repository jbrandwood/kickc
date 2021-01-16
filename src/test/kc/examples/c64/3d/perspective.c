// 3D Rotation using a Rotation Matrix
// Based on: 
// - C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// - Codebase64 Article http://codebase64.org/doku.php?id=base:3d_rotation  
#include <c64.h>
#include <print.h>

// The rotated point - updated by calling rotate()
signed char* xr = $f0;
signed char* yr = $f1;
signed char* zr = $f2;

// Pointers used to multiply perspective (d/z0-z) onto x- & y-coordinates. Points into mulf_sqr1 / mulf_sqr2.  
unsigned int* psp1 = $f3;
unsigned int* psp2 = $f5;

void main() {
	asm { sei }
	mulf_init();
	*psp1 = (unsigned int)mulf_sqr1;
	*psp2 = (unsigned int)mulf_sqr2;
	print_cls();
	do_perspective($39, -$47, $36);
	/*
	signed char xy = -$3f;
	do_perspective(xy, xy, -$3f);
	do_perspective(xy, xy, -$30);
	do_perspective(xy, xy, -$20);
	do_perspective(xy, xy, -$10);
	do_perspective(xy, xy, $00);
	do_perspective(xy, xy, $10);
	do_perspective(xy, xy, $20);
	do_perspective(xy, xy, $30);
	do_perspective(xy, xy, $3f);
	*/
}


void do_perspective(signed char x, signed char y, signed char z) {
	print_str("(");
	print_schar(x);
	print_str(",");
	print_schar(y);
	print_str(",");
	print_schar(z);
	print_str(") -> (");
	perspective(x, y, z);
	print_uchar((byte)*xr);
	print_str(",");
	print_uchar((byte)*yr);
	print_str(")");
	print_ln();	
}


// Apply perspective to a 3d-point. Result is returned in (*xr,*yr) 
// Implemented in assembler to utilize seriously fast multiplication 
void perspective(signed char x, signed char y, signed char z) {
	*xr = x;
	*yr = y;
	*zr = z;
	asm {

			// Update index in perspective lookup
			lda zr
			sta PP+1
		PP: lda PERSP_Z
			sta psp1
			eor #$ff
			sta psp2 			

			// Calculate perspective for Y-position
			clc
			ldy yr
			lda (psp1),y
			sbc (psp2),y
			adc #$80
			sta yr

			// Calculate perspective for X-position
			clc
			ldy xr
			lda (psp1),y
			sbc (psp2),y
			adc #$80
			sta xr
	}
}

// Multiplication tables for seriously fast multiplication. 
// This version is optimized for speed over accuracy
// - It can multiply signed numbers with no extra code - but only for numbers in [-$3f;$3f]  
// - It throws away the low part of the 32-bit result
// - It return >a*b*4 to maximize precision (when passed maximal input values $3f*$3f the result is $3e) 
// See the following for information about the method
// - http://codebase64.org/doku.php?id=base:seriously_fast_multiplication 
// - http://codebase64.org/doku.php?id=magazines:chacking16
// mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
// f(x) = >(( x * x ))
char __align($100) mulf_sqr1[512];
// g(x) =  >((( 1 - x ) * ( 1 - x )))
char __align($100) mulf_sqr2[512];

// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x) and g(x) = f(1-x) 
void mulf_init() {
	signed int sqr = 0;	
	signed int add = 1;
	for( char i:0..128) {
		char val = >sqr;
		mulf_sqr1[i] = val;
		(mulf_sqr1+$100)[i] = val;
		mulf_sqr1[-i] = val;
		(mulf_sqr1+$100)[-i] = val;
		mulf_sqr2[i+1] = val;
		(mulf_sqr2+$100)[i+1] = val;
		mulf_sqr2[1-i] = val;
		(mulf_sqr2+$100)[1-i] = val;
		sqr += add;
		add +=2;
	}
}

// Perspective multiplication table containing (d/(z0-z)[z] for each z-value   
signed char __align(0x100) PERSP_Z[0x100] = kickasm {{
    {
    .var d = 256.0	
    .var z0 = 5.0	
    .for(var z=0;z<$100;z++) {
    	.if(z>127) {
    		.byte round(d / (z0 - ((z - 256) / 64.0)));
    	} else {
    		.byte round(d / (z0 - (z / 64.0)));
    	}
    }
	}
}};
