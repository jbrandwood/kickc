// Illustrates a problem with a missing fragment - pbuc1_derefidx_vwuz1=vbuz2
#include <c64.h>
#include <c64-keyboard.h>
#include <string.h>
#include <multiply.h>

byte* const screen = (byte*)$400;
byte* const charset = (byte*)$2000;
byte* const tileset = (byte*)$2800;
byte* const colors = (byte*)$d800;
byte* const level_address = (byte*)$3000;

void main() {
    init();
	for (byte x = 0; x < 16; x++ ){
		for (byte y = 0; y < 9; y++) {
			byte z = x+y;
			byte tile = level_address[z];
			draw_block(tile,x,y,YELLOW);
		}
	}
    do {
    } while(true); 
}

void init() {
	init_sprites();
	memset(screen, 0, 1000);
	memset(colors, BLACK, 1000);
	*D018 = toD018(screen, charset);
	asm {
		lda #$5b   // as there are more than 256 rasterlines, the topmost bit of $d011 serves as
		sta $d011  // the 8th bit for the rasterline we want our irq to be triggered.
	}
	*BORDER_COLOR = BLACK;
	*BG_COLOR = BLACK;
	*BG_COLOR1 = RED;
	*BG_COLOR2 = BLUE;
	*BG_COLOR3 = GREEN;
} 

void init_sprites() {
	*SPRITES_ENABLE = %00000001; // one sprite enabled
	*SPRITES_EXPAND_X = 0;
	*SPRITES_EXPAND_Y = 0;
	*SPRITES_XMSB = 0;
	*SPRITES_COLOR = WHITE;
	*SPRITES_MC = 0;
}

void draw_block(byte tileno, byte x, byte y, byte color) {
	tileno = tileno << 2;
	word x1 = x << 1;
	y = y << 1;
	word z = mul8u(y,40);
	z = z + x1;
	byte drawtile = tileset[tileno];
	screen[z] = drawtile;
	colors[z] = YELLOW;
	screen[z+1] = 1;
	colors[z+1] = YELLOW;
	screen[z+40] = 2;
	colors[z+40] = YELLOW;
	screen[z+41] = 3;
	colors[z+41] = YELLOW;
}