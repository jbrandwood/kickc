// 3D Rotation using a Rotation Matrix
// Based on: 
// - C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
// - Codebase64 Article http://codebase64.org/doku.php?id=base:3d_rotation  
#include <c64.h>
#include <c64-print.h>

// The rotated point - updated by calling rotate_matrix()
signed char xr;
signed char yr;
signed char zr;

// The rotated point with perspective
signed char pp;
signed char xp;
signed char yp;

// Pointers used to multiply perspective (d/z0-z) onto x- & y-coordinates. Points into mulf_sqr1 / mulf_sqr2  
unsigned int psp1;
unsigned int psp2;

char* SCREEN = (char*)$400;

void main() {
	asm { sei }
	sprites_init();
	//mulf_init();
	psp1 = (unsigned int)mulf_sqr1;
	psp2 = (unsigned int)mulf_sqr2;

	debug_print_init();

 	//calculate_matrix(1,1,1);

	anim();
}

// Positions to rotate
signed char xs[8] = { -52, -52, -52,   0,  0,   52,  52,  52};
signed char ys[8] = { -52,   0,  52, -52,  52, -52,   0,  52};
signed char zs[8] = {  52,  52,  52,  52,  52,  52,  52,  52};
// Rotated positions
signed char xrs[8];
signed char yrs[8];
signed char zrs[8];
// Perspective factors (from zrs)
signed char pps[8];
// Rotated positions with perspective
signed char xps[8];
signed char yps[8];

signed char sx = 0;
signed char sy = 0;
signed char sz = 0;

void anim() {
	while(true) {
		while(VICII->RASTER!=$ff) {}
		while(VICII->RASTER!=$fe) {}
		while(VICII->RASTER!=$fd) {}
        (VICII->BORDER_COLOR)++;
    	//calculate_matrix_16(sx,sy,sz);
    	calculate_matrix(sx,sy,sz);
    	store_matrix();
        for(char i: 0..7) {
            (VICII->BORDER_COLOR)++;
            rotate_matrix(xs[i], ys[i], zs[i]);
            xrs[i] = xr;
            yrs[i] = yr;
            zrs[i] = zr;
            pps[i] = pp;
            xps[i] = xp;
            yps[i] = yp;
            char i2 = i*2;
       	    SPRITES_XPOS[i2] = $80+(char)(xp);
       	    SPRITES_YPOS[i2] = $80+(char)(yp);
    	}
        VICII->BORDER_COLOR = LIGHT_GREY;
        debug_print();
        VICII->BORDER_COLOR = LIGHT_BLUE;
        // Increment angles        
    	sx +=2;
	  	sy -=3;
    	//sz +=1;
	}	
}

void debug_print_init() {
	print_cls();
	print_str_at("sx", SCREEN+40*0+34);
	print_str_at("sy", SCREEN+40*1+34);
	print_str_at("sz", SCREEN+40*2+34);
	print_str_at("x", SCREEN+40*16);
	print_str_at("y", SCREEN+40*17);
	print_str_at("z", SCREEN+40*18);
	print_str_at("xr", SCREEN+40*19);
	print_str_at("yr", SCREEN+40*20);
	print_str_at("zr", SCREEN+40*21);
	print_str_at("pp", SCREEN+40*22);
	print_str_at("xp", SCREEN+40*23);
	print_str_at("yp", SCREEN+40*24);

    char* at_line = SCREEN+16*40;
 	char c = 4;
 	char* COLS = (char*)$d800;
 	char* at_cols = COLS+16*40;
    for( char i: 0..7) {
    	print_schar_at(xs[i], at_line+40*0+c);
    	print_schar_at(ys[i], at_line+40*1+c);
    	print_schar_at(zs[i], at_line+40*2+c);
    	for( char j: 0..3) {
    		char col = 8+i;
    		*(at_cols+40*0+c+j) = col;
    		*(at_cols+40*1+c+j) = col;
    		*(at_cols+40*2+c+j) = col;
    		*(at_cols+40*3+c+j) = col;
    		*(at_cols+40*4+c+j) = col;
    		*(at_cols+40*5+c+j) = col;
    		*(at_cols+40*6+c+j) = col;
    		*(at_cols+40*7+c+j) = col;
    		*(at_cols+40*8+c+j) = col;
    	}
    	c += 4;
    }


}

void debug_print() {
	// angles
    print_schar_pos(sx, 0, 37);
    print_schar_pos(sy, 1, 37);
    print_schar_pos(sz, 2, 37);
    // rotation matrix
    print_schar_pos(rotation_matrix[0], 4, 29);
    print_schar_pos(rotation_matrix[1], 4, 33);
    print_schar_pos(rotation_matrix[2], 4, 37);
    print_schar_pos(rotation_matrix[3], 5, 29);
    print_schar_pos(rotation_matrix[4], 5, 33);
    print_schar_pos(rotation_matrix[5], 5, 37);
    print_schar_pos(rotation_matrix[6], 6, 29);
    print_schar_pos(rotation_matrix[7], 6, 33);
    print_schar_pos(rotation_matrix[8], 6, 37);
    char* at_line = SCREEN+19*40;
 	char c = 4;
    for( char i: 0..7) {
    	print_schar_at(xrs[i], at_line+40*0+c);
    	print_schar_at(yrs[i], at_line+40*1+c);
    	print_schar_at(zrs[i], at_line+40*2+c);
    	print_schar_at(pps[i], at_line+40*3+c);
    	print_schar_at(xps[i], at_line+40*4+c);
    	print_schar_at(yps[i], at_line+40*5+c);
    	c += 4;
    }
}

// Initialize sprites
void sprites_init() {
	char* SCREEN = (char*)$400;
    VICII->SPRITES_ENABLE = %11111111;
    char* sprites_ptr = SCREEN+$3f8;
    for(char i: 0..7) {
    	sprites_ptr[i] = (char)(SPRITE/$40);
        SPRITES_COLOR[i] = GREEN; //8+i;
    }
}

// The rotation matrix
signed char rotation_matrix[9];

// Prepare the 3x3 rotation matrix into rotation_matrix[]
// Angles sx, sy, sz are based on 2*PI=$100 
// Method described in C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
void calculate_matrix(signed char sx, signed char sy, signed char sz) {
	signed char t1 = sy-sz;
	signed char t2 = sy+sz;
	signed char t3 = sx+sz;
	signed char t4 = sx-sz;
	signed char t5 = sx+t2; // = sx+sy+sz
	signed char t6 = sx-t1; // = sx-sy+sz
	signed char t7 = sx+t1; // = sx+sy-sz
	signed char t8 = t2-sx; // = sy+sz-sx
	signed char t9 = sy-sx;
	signed char t10 = sy+sx;
	rotation_matrix[0] = COSH[t1]+COSH[t2];
	rotation_matrix[1] = SINH[t1]-SINH[t2];
	rotation_matrix[2] = SINH[sy]+SINH[sy];
	rotation_matrix[3] = SINH[t3]-SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t8]-COSQ[t7];
	rotation_matrix[4] = COSH[t3]+COSH[t4] + SINQ[t5]-SINQ[t6]-SINQ[t7]-SINQ[t8];
	rotation_matrix[5] = SINH[t9]-SINH[t10];
	rotation_matrix[6] = COSH[t4]-COSH[t3] + SINQ[t6]-SINQ[t5]-SINQ[t8]-SINQ[t7];
	rotation_matrix[7] = SINH[t3]+SINH[t4] + COSQ[t6]-COSQ[t5]+COSQ[t7]-COSQ[t8];
	rotation_matrix[8] = COSH[t9]+COSH[t10];
}

// Prepare the 3x3 rotation matrix into rotation_matrix[] using 16-bit sines for improved accuracy.
// Angles sx, sy, sz are based on 2*PI=$100 
// Method described in C= Hacking Magazine Issue 8. http://www.ffd2.com/fridge/chacking/c=hacking8.txt
void calculate_matrix_16(signed char sx, signed char sy, signed char sz) {
	signed char t1 = sy-sz;
	signed char t2 = sy+sz;
	signed int cosh_t1 = (signed int){ COSH_HI[t1], COSH_LO[t1] };
	signed int cosh_t2 = (signed int){ COSH_HI[t2], COSH_LO[t2] };
	rotation_matrix[0] = round_hi(cosh_t1 + cosh_t2);
	signed int sinh_t1 = (signed int){ SINH_HI[t1], SINH_LO[t1] };
	signed int sinh_t2 = (signed int){ SINH_HI[t2], SINH_LO[t2] };	
	rotation_matrix[1] = round_hi(sinh_t1 - sinh_t2);
	signed int sinh_sy = (signed int){ SINH_HI[sy], SINH_LO[sy] };	
	rotation_matrix[2] = round_hi(sinh_sy+sinh_sy);
	signed char t3 = sx+sz;
	signed char t4 = sx-sz;
	signed char t5 = sx+t2; // = sx+sy+sz
	signed char t6 = sx-t1; // = sx-sy+sz
	signed char t7 = sx+t1; // = sx+sy-sz
	signed char t8 = t2-sx; // = sy+sz-sx
	signed int sinh_t3 = (signed int){ SINH_HI[t3], SINH_LO[t3] };
	signed int sinh_t4 = (signed int){ SINH_HI[t4], SINH_LO[t4] };	
	signed int cosq_t5 = (signed int){ COSQ_HI[t5], COSH_LO[t5] };
	signed int cosq_t6 = (signed int){ COSQ_HI[t6], COSH_LO[t6] };
	signed int cosq_t7 = (signed int){ COSQ_HI[t7], COSH_LO[t7] };
	signed int cosq_t8 = (signed int){ COSQ_HI[t8], COSH_LO[t8] };
	rotation_matrix[3] = round_hi(sinh_t3 - sinh_t4 + cosq_t6 - cosq_t5 + cosq_t8 - cosq_t7);
	rotation_matrix[7] = round_hi(sinh_t3 + sinh_t4 + cosq_t6 - cosq_t5 + cosq_t7 - cosq_t8);
	signed int cosh_t3 = (signed int){ COSH_HI[t3], COSH_LO[t3] };
	signed int cosh_t4 = (signed int){ COSH_HI[t4], COSH_LO[t4] };	
	signed int sinq_t5 = (signed int){ SINQ_HI[t5], SINH_LO[t5] };
	signed int sinq_t6 = (signed int){ SINQ_HI[t6], SINH_LO[t6] };
	signed int sinq_t7 = (signed int){ SINQ_HI[t7], SINH_LO[t7] };
	signed int sinq_t8 = (signed int){ SINQ_HI[t8], SINH_LO[t8] };
	rotation_matrix[4] = round_hi( cosh_t3 + cosh_t4 + sinq_t5 - sinq_t6 - sinq_t7 - sinq_t8);
	rotation_matrix[6] = round_hi( cosh_t4 - cosh_t3 + sinq_t6 - sinq_t5 - sinq_t7 - sinq_t8);
	signed char t9 = sy-sx;
	signed char t10 = sy+sx;
	signed int sinh_t9 = (signed int){ SINH_HI[t9], SINH_LO[t9] };
	signed int sinh_t10 = (signed int){ SINH_HI[t10], SINH_LO[t10] };	
	rotation_matrix[5] = round_hi( sinh_t9 - sinh_t10);
	signed int cosh_t9 = (signed int){ COSH_HI[t9], COSH_LO[t9] };
	signed int cosh_t10 = (signed int){ COSH_HI[t10], COSH_LO[t10] };
	rotation_matrix[8] = round_hi( cosh_t9 + cosh_t10 );
}

// Returns the rounded high char of the passed signed int.
// Examines the lower char to determine whether to round up or down
signed char round_hi(signed int val) {
	return (signed char)BYTE1(val+$80);
}


// Store the rotation matrix into the rotation routine rotate()
// After this each call to rotate() will rotate a point with the matrix
// Implemented in assembler to utilize seriously fast multiplication 
void store_matrix() {
	asm {
		lda rotation_matrix+0
		sta rotate_matrix.A1+1
		eor #$ff
		sta rotate_matrix.A2+1
		lda rotation_matrix+1
		sta rotate_matrix.B1+1
		eor #$ff
		sta rotate_matrix.B2+1
		lda rotation_matrix+2
		sta rotate_matrix.C1+1
		eor #$ff
		sta rotate_matrix.C2+1
		lda rotation_matrix+3
		sta rotate_matrix.D1+1
		eor #$ff
		sta rotate_matrix.D2+1
		lda rotation_matrix+4
		sta rotate_matrix.E1+1
		eor #$ff
		sta rotate_matrix.E2+1
		lda rotation_matrix+5
		sta rotate_matrix.F1+1
		eor #$ff
		sta rotate_matrix.F2+1
		lda rotation_matrix+6
		sta rotate_matrix.G1+1
		eor #$ff
		sta rotate_matrix.G2+1
		lda rotation_matrix+7
		sta rotate_matrix.H1+1
		eor #$ff
		sta rotate_matrix.H2+1
		lda rotation_matrix+8
		sta rotate_matrix.I1+1
		eor #$ff
		sta rotate_matrix.I2+1
	}	
}

// Rotate a 3D point (x,y,z) using the rotation matrix
// The rotation matrix is prepared by calling prepare_matrix() 
// The passed points must be in the interval [-$3f;$3f].
// Implemented in assembler to utilize seriously fast multiplication 
void rotate_matrix(signed char x, signed char y, signed char z) {
	xr = x;
	yr = y;
	zr = z;
	asm {
			ldx zr //z
			// C*z 
		C1:	lda mulf_sqr1,x
			sec
		C2: sbc mulf_sqr2,x
			sta C3+1
			// F*z 
		F1:	lda mulf_sqr1,x
			sec
		F2: sbc mulf_sqr2,x
			sta F3+1
			// I*z 
		I1:	lda mulf_sqr1,x
			sec
		I2: sbc mulf_sqr2,x
			sta I3+1

			ldx xr //x
			ldy yr //y

		I3: lda #0 // I*z
			clc
		G1:	adc mulf_sqr1,x
			sec
		G2: sbc mulf_sqr2,x
			clc
		H1:	adc mulf_sqr1,y
			sec
		H2: sbc mulf_sqr2,y
			sta zr

			sta PP+1
		PP: lda PERSP_Z
			sta pp
			sta psp1
			eor #$ff
			sta psp2 			

		C3: lda #0 // C*z
			clc
		A1:	adc mulf_sqr1,x
			sec
		A2: sbc mulf_sqr2,x
			clc
		B1:	adc mulf_sqr1,y
			sec
		B2: sbc mulf_sqr2,y
			sta xr
			// divide x by 2 to get x below $3f for multiplication
			//cmp #$80
			//ror
			sta XX+1
			clc

		F3: lda #0 // F*z
			clc
		D1:	adc mulf_sqr1,x
			sec
		D2: sbc mulf_sqr2,x
			clc
		E1:	adc mulf_sqr1,y
			sec
		E2: sbc mulf_sqr2,y
			sta yr

			// Calculate perspective for Y-position
			// divide y by 2 to get x below $3f for multiplication
			//cmp #$80
			//ror
			tay
			lda (psp1),y
			sec
			sbc (psp2),y
			sta yp

			// Calculate perspective for X-position
		XX:	ldy #0
			lda (psp1),y
			sec
			sbc (psp2),y
			sta xp
	}
}

// mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
// f(x) = >(( x * x ))
char __align(0x100) mulf_sqr1[0x200] = kickasm {{
    .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }
}};

// g(x) =  >((( 1 - x ) * ( 1 - x )))
char __align(0x100) mulf_sqr2[0x200] = kickasm {{
    .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }
}};

/*
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
byte __align($100) mulf_sqr1[512];
// g(x) =  >((( 1 - x ) * ( 1 - x )))
byte __align($100) mulf_sqr2[512];

// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x) and g(x) = f(1-x) 
void mulf_init() {
	signed int sqr = 0;	
	signed int add = 1;
	for( byte i:0..128) {
		byte val = >sqr;
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
*/

// A single sprite
__address(0x3000) char SPRITE[] = kickasm(resource "balloon.png") {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

// Perspective multiplication table containing (d/(z0-z)[z] for each z-value   
signed char __align(0x100) PERSP_Z[0x100] = kickasm {{
    {
    .var d = 256.0	
    .var z0 = 6.0	
    // These values of d/z0 result in table values from $20 to $40 (effectively max is $3f)
    .for(var z=0;z<$100;z++) {
    	.if(z>127) {
    		.byte round(d / (z0 - ((z - 256) / 64.0)));
    	} else {
    		.byte round(d / (z0 - (z / 64.0)));
    	}
    }
	}
}};

// Sine and Cosine Tables   
// Angles: $00=0, $80=PI,$100=2*PI
// Half Sine/Cosine: signed fixed [-$20;20]
signed char __align(0x40) SINH[0x140] = kickasm {{
    {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }
}};
signed char* COSH = SINH+$40; // sin(x) = cos(x+PI/2)

// Quarter Sine/Cosine: signed fixed [-$10,$10]
signed char __align(0x40) SINQ[0x140] = kickasm {{
    {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte round((min+(ampl/2)+(ampl/2)*sin(rad))/256)
    }
    }
}};
signed char* COSQ = SINQ+$40; // sin(x) = cos(x+PI/2)

// 16 bit Sine and Cosine Tables   
// Angles: $00=0, $80=PI,$100=2*PI
// Half Sine/Cosine: signed fixed [-$1f,$1f]
char __align(0x40) SINH_LO[0x140] = kickasm {{
    {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte <(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }
}};
char* COSH_LO = SINH_LO+$40; // sin(x) = cos(x+PI/2)

char __align(0x40) SINH_HI[0x140] = kickasm {{
    {
    .var min = -$2000
    .var max = $2000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }
}};
char* COSH_HI = SINH_HI+$40; // sin(x) = cos(x+PI/2)

// Quarter Sine/Cosine: signed fixed [-$0f,$0f]
char __align(0x40) SINQ_LO[0x140] = kickasm {{
    {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte <(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }
}};
char* COSQ_LO = SINQ_LO+$40; // sin(x) = cos(x+PI/2)

char __align(0x40) SINQ_HI[0x140] = kickasm {{
    {
    .var min = -$1000
    .var max = $1000
    .var ampl = max-min;
    .for(var i=0;i<$140;i++) {
        .var rad = i*2*PI/256;
        .byte >(min+(ampl/2)+(ampl/2)*sin(rad))
    }
    }
}};
char* COSQ_HI = SINQ_HI+$40; // sin(x) = cos(x+PI/2)

