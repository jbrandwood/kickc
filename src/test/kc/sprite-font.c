// Create a sprite font using lines

#include <c64.h>
#include <string.h>

char* const SCREEN = (char*)0x0400;
char* const SPRITE = 0x2000;
char* const SPRITES = SCREEN+OFFSET_SPRITE_PTRS;

void* const GENERATOR = 0x0900;

void main() {
	memset(SCREEN, ' ', 1000);
	*SPRITES_ENABLE = 1;
    SPRITES_XPOS[0] = 100;
	SPRITES_YPOS[0] = 100;
	SPRITES_COLOR[0] = WHITE;
	SPRITES[0] = toSpritePtr(SPRITE);
	memset(SPRITE,0,64);
	asm { jsr GENERATOR }
}

kickasm (pc GENERATOR) {{
    .label line_idx=$f6
    .label line_def=$f7
    .label line_xpos=$f7
    .label line_ypos=$f8
    .label line_xadd=$f9
    .label line_yadd=$fa
    .label line_len =$fb

    .label xpos=$fc
    .label ypos=$fd

    .label sprite=$fe

init:
	lda #<SPRITE
	sta sprite
	lda #>SPRITE
	sta sprite+1
	lda #0
	sta line_idx 	
lines: // Draw a number of lines th make up a letter
    ldy #0
    ldx line_idx
!:
    lda LINES,x
    sta line_def,y
    inx
    iny
    cpy #5
    bne !-
    stx line_idx
    cpx #LINES_END-LINES+5
    bcc !+
    rts
!:
    jsr line
    jmp lines

line: // Draw a single line using uint[5.3] fixed point additions to xpos & ypos
    lda line_xpos
    lsr
    lsr
    lsr
    sta xpos
    lda line_ypos
    lsr
    lsr
    lsr
    sta ypos
    jsr plot
    clc
    lda line_xpos
    adc line_xadd
    sta line_xpos
    clc
    lda line_ypos
    adc line_yadd
    sta line_ypos
    dec line_len
    bne line
    rts
plot:  // plots one point (xpos,ypos) into a sprite
	ldx #7
	lda xpos
	axs #0    // X = xpos&7
	lsr
	lsr
	lsr
	clc
	adc ypos
	adc ypos
	adc ypos
	tay        // Y = xpos/8+ypos*3
    lda #0
    sec
!:
    ror
    dex
    bpl !-    // A = xpos bit
	ora (sprite),y
	sta (sprite),y
	rts
// Table with line definitions (uint[5.3] x_start, uint[5.3] y_start, uint[5.3] x_add, uint[5.3] y_add, uint8 length)
LINES:
/*
    // A
    linedef(  0, 20, 12,  0)
    linedef( 11,  0, 23, 20)
    linedef(  0, 11, 23, 11)
    // B
    linedef(  0,  0,  0, 20)
    linedef(  0,  0, 23,  6)
    linedef(  0, 10, 23,  4)
    linedef(  0, 10, 23, 16)
    linedef(  0, 20, 23, 14)
    // C
*/
    linedef(  0,  6, 12,  0)
    linedef( 11,  0, 23,  6)
    linedef(  0,  6,  0, 14)
    linedef(  0, 14, 12, 20)
    linedef( 11, 20, 23, 15)
LINES_END:


// Generates a line definition for a specific line
// Output format (uint[5.3] x_start, uint[5.3] y_start, uint[5.3] x_add, uint[5.3] y_add, uint8 length)
.macro linedef(from_x, from_y, to_x, to_y) {
    .var d_x = to_x-from_x;
    .var d_y = to_y-from_y;
    .if(abs(d_x)<abs(d_y)) {
        .var len = abs(d_y)
        .byte 4+8*from_x, 4+8*from_y, 8*d_x/len, 8*d_y/len, len+1
    } else {
        .var len = abs(d_x)
        .byte 4+8*from_x, 4+8*from_y, 8*d_x/len, 8*d_y/len, len+1
    }
}


}}