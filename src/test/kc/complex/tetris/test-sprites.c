#include "tetris-sprites.c"

char SIN[256] = kickasm {{
    .var AMPL = 200-21
    .for(var i=0; i<256; i++) {
  	  .byte 51+AMPL/2+sin(toRadians([i*360]/256))*AMPL/2
    }
}};

char* SIN_SPRITE = 0x2800;
kickasm(pc SIN_SPRITE) {{
    .fill $40, $ff
}}

char sin_idx = 0;

void main() {
	vicSelectGfxBank(PLAYFIELD_SCREEN_1);
	*D018 = toD018(PLAYFIELD_SCREEN_1, PLAYFIELD_CHARSET);
	sprites_init();

	*SPRITES_ENABLE = 0xff;

    char xpos = 24;
    char ypos = 50;
    for(char s:4..7) {
    	char s2 = s*2;
		SPRITES_XPOS[s2] = xpos;
		SPRITES_YPOS[s2] = ypos;
		SPRITES_COLS[s] = s-3;
		PLAYFIELD_SPRITE_PTRS_1[s] = toSpritePtr(SIN_SPRITE);
		xpos +=  24;
		ypos +=  24;
    }

    sprites_irq_init();
    loop();
}


void loop() {
    while(true) {
        do {} while (*RASTER!=0xff);
        char idx = sin_idx;
        for(char s:4..7) {
    		SPRITES_YPOS[s*2] = SIN[idx];
    		idx += 10;
        }
        sin_idx++;

    }
}
