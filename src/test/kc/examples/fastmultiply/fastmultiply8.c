// Seriously fast multiply 8-bit version (8bit*8bit=8bit)
// Multiplies two signed 8-bit numbers and results in an 8-bit number
// C=A*B, A in [-64;64], B in [-96;95], C in [-96;95] - 64 acts a 1 (X*64=X)
// Uses the formula a*b = (a+b)^2/4 - (a-b)^2/4
// See the following for information about the method
// - http://codebase64.org/doku.php?id=base:seriously_fast_multiplication 
// - http://codebase64.org/doku.php?id=magazines:chacking16

#include <print.c>

signed char vals[] = {-95, -64, -32, -16, 0, 16, 32, 64, 95};

void main() {
	init_screen();
	char* at_line = $400;
	char* at = at_line+4;
	for(char k: 0..8) {
		print_sbyte_at(vals[k], at);
		at += 4;
	}
	for(char i: 0..8) {
		at_line +=40;
		at = at_line;
		print_sbyte_at(vals[i], at);
		for(char j: 0..8) {
			at += 4;		
			signed char r = fmul8(vals[i], vals[j]);
			print_sbyte_at(r, at);			
		}
	}
}

void init_screen() {
	print_cls();
	char* COLS = $d800;
	char WHITE = 1;
	for(char l: 0..39) {
		COLS[l] = WHITE;
	}
	for(char m: 0..24) {
		COLS[0] = WHITE;
		COLS[1] = WHITE;
		COLS[2] = WHITE;
		COLS[3] = WHITE;
		COLS += 40;
	}

}

// Pointers to a, b and c=a*b
signed char* ap = $fd;
signed char* bp = $fe;
signed char* cp = $ff;

signed char fmul8(signed char a, signed char b) {
	*ap = a;
	*bp = b;
	asm {
		lda ap
		sta A1+1
		eor #$ff
		sta A2+1
		ldx bp
		sec
		A1:	lda mulf_sqr1,x
		A2: sbc mulf_sqr2,x
		sta cp
	}
	return *cp;
}

// mulf_sqr tables will contain f(x)=int(x*x) and g(x) = f(1-x).
// f(x) = >(( x * x ))
char align(0x100) mulf_sqr1[0x200] = kickasm {{
    .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((i*i)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((i-256)*(i-256))/256) }
    	.if(i>351) { .byte round(((512-i)*(512-i))/256) }
    }
}};


// g(x) =  >((( 1 - x ) * ( 1 - x )))
char align(0x100) mulf_sqr2[0x200] = kickasm {{
    .for(var i=0;i<$200;i++) {
    	.if(i<=159) { .byte round((-i-1)*(-i-1)/256) }
    	.if(i>159 && i<=351 ) { .byte round(((255-i)*(255-i))/256) }
    	.if(i>351) { .byte round(((i-511)*(i-511))/256) }  
    }
}};