// 2D rotattion of 8 sprites 

#include <c64.h>
#include <fastmultiply.h>
#include <time.h>
#include <print.h>

char* SCREEN = $0400;

// Sine and Cosine tables  
// Angles: $00=0, $80=PI,$100=2*PI
// Sine/Cosine: signed fixed [-$7f,$7f]
char align(0x40) SIN[0x140] = kickasm {{
    .for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))
}};

char* COS = SIN+$40; // sin(x) = cos(x+PI/2)

void main() {
	asm { sei }
	init();
	anim();
}

void init() {
    mulf_init();	
    VICII->SPRITES_ENABLE = %11111111;
    char* sprites_ptr = SCREEN+$3f8;
    for(char i: 0..7) {
    	sprites_ptr[i] = (char)(SPRITE/$40);
        SPRITES_COLS[i] = GREEN;
    }
}

// Positions to rotate
signed char xs[8] = { -70, -70, -70,   0,   0,  70,  70,  70};
signed char ys[8] = { -70,   0,  70, -70,  70, -70,   0,  70};

void anim() {
	char angle = 0;
	while(true) {
		while(VICII->RASTER!=$ff) {}
        (VICII->BORDER_COLOR)++;
        clock_start();
        signed char cos_a = (signed char) COS[angle]; // signed fixed[0.7]
        signed char sin_a = (signed char) SIN[angle]; // signed fixed[0.7]
        char sprite_msb = 0;
        for(char i: 0..7) {
            signed char x = xs[i]; // signed fixed[7.0]
            signed char y = ys[i]; // signed fixed[7.0]
            mulf8s_prepare(cos_a);
            signed int xr = mulf8s_prepared(x)*2; // signed fixed[8.8]
            signed int yr = mulf8s_prepared(y)*2; // signed fixed[8.8]
            mulf8s_prepare(sin_a);
	        xr -= mulf8s_prepared(y)*2; // signed fixed[8.8]
		    yr += mulf8s_prepared(x)*2; // signed fixed[8.8]
		    signed int xpos = ((signed char) >xr) + 24 /*border*/ + 149 /*center*/;
            sprite_msb = sprite_msb/2;
            if(>xpos!=0) {
                sprite_msb |= $80;
            }
            char ypos = (>yr) + 89 /*center*/+ 51 /*border*/;
            char i2 = i*2;
       	    SPRITES_XPOS[i2] = <xpos;
       	    SPRITES_YPOS[i2] = ypos;
        }
        VICII->SPRITES_XMSB = sprite_msb;
		angle++;
        // Calculate the cycle count - 0x12 is the base usage of start/read
        unsigned long cyclecount = clock()-CLOCKS_PER_INIT;
        // Print cycle count
        print_ulong_at(cyclecount, SCREEN);
		VICII->BORDER_COLOR = LIGHT_BLUE;
	}
}

// A single sprite
char* SPRITE = $3000;
kickasm(pc SPRITE, resource "balloon.png") {{
    .var pic = LoadPicture("balloon.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}}
