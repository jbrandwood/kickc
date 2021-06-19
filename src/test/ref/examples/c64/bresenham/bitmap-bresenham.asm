/// @file
/// @brief Commodore 64 Registers and Constants
/// @file
/// @brief The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="bitmap-bresenham.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const VICII_BMM = $20
  .const VICII_DEN = $10
  .const VICII_RSEL = 8
  .const WHITE = 1
  .const LINES = 8
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .label D011 = $d011
  .label VICII_MEMORY = $d018
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label SCREEN = $400
  .label BITMAP = $2000
.segment Code
main: {
    // VICII->BORDER_COLOR = 0
    lda #0
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = 0
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta D011
    // *VICII_MEMORY =  (char)((((unsigned int)SCREEN&$3fff)/$40)|(((unsigned int)BITMAP&$3fff)/$400))
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VICII_MEMORY
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // init_screen()
    jsr init_screen
  __b1:
    // lines()
    jsr lines
    jmp __b1
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $e
    .label yoffs = 2
    ldx #0
    lda #$80
  __b1:
    // bitmap_plot_bit[x] = bits
    sta bitmap_plot_bit,x
    // bits >>= 1
    lsr
    // if(bits==0)
    cmp #0
    bne __b2
    lda #$80
  __b2:
    // for(char x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    // y&$7
    lda #7
    sax.z __7
    // BYTE0(yoffs)
    lda.z yoffs
    // y&$7 | BYTE0(yoffs)
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | BYTE0(yoffs)
    sta bitmap_plot_ylo,x
    // BYTE1(yoffs)
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = BYTE1(yoffs)
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(char y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
    // memset(bitmap_screen, col, 1000uw)
    ldx #col
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // memset(bitmap_gfx, 0, 8000uw)
    ldx #0
    lda #<BITMAP
    sta.z memset.str
    lda #>BITMAP
    sta.z memset.str+1
    lda #<$1f40
    sta.z memset.num
    lda #>$1f40
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
init_screen: {
    .label c = 2
    lda #<SCREEN
    sta.z c
    lda #>SCREEN
    sta.z c+1
  __b1:
    // for(char* c = SCREEN; c!=SCREEN+$400;c++)
    lda.z c+1
    cmp #>SCREEN+$400
    bne __b2
    lda.z c
    cmp #<SCREEN+$400
    bne __b2
    // }
    rts
  __b2:
    // *c = $14
    lda #$14
    ldy #0
    sta (c),y
    // for(char* c = SCREEN; c!=SCREEN+$400;c++)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
}
lines: {
    .label l = $e
    lda #0
    sta.z l
  __b1:
    // for(char l=0; l<LINES;l++)
    lda.z l
    cmp #LINES
    bcc __b2
    // }
    rts
  __b2:
    // bitmap_line(lines_x[l], lines_y[l], lines_x[l+1], lines_y[l+1])
    ldy.z l
    lda lines_x,y
    sta.z bitmap_line.x1
    lda #0
    sta.z bitmap_line.x1+1
    lda lines_y,y
    sta.z bitmap_line.y1
    lda #0
    sta.z bitmap_line.y1+1
    lda lines_x+1,y
    sta.z bitmap_line.x2
    lda #0
    sta.z bitmap_line.x2+1
    lda lines_y+1,y
    sta.z bitmap_line.y2
    lda #0
    sta.z bitmap_line.y2+1
    jsr bitmap_line
    // for(char l=0; l<LINES;l++)
    inc.z l
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(4) str, byte register(X) c, word zp(2) num)
memset: {
    .label end = 2
    .label dst = 4
    .label num = 2
    .label str = 4
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zp(4) x1, word zp(6) y1, word zp($f) x2, word zp($11) y2)
bitmap_line: {
    .label dx = $13
    .label dy = $a
    .label sx = $15
    .label sy = $c
    .label e1 = 8
    .label e = 2
    .label y = 6
    .label x = 4
    .label x1 = 4
    .label y1 = 6
    .label x2 = $f
    .label y2 = $11
    // abs_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    sta.z abs_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // abs_u16(x2-x1)
    // unsigned int dx = abs_u16(x2-x1)
    lda.z abs_u16.return
    sta.z dx
    lda.z abs_u16.return+1
    sta.z dx+1
    // abs_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    sta.z abs_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // abs_u16(y2-y1)
    // unsigned int dy = abs_u16(y2-y1)
    // if(dx==0 && dy==0)
    lda.z dx
    ora.z dx+1
    bne __b1
    lda.z dy
    ora.z dy+1
    bne !__b4+
    jmp __b4
  !__b4:
  __b1:
    // sgn_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    sta.z sgn_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // sgn_u16(x2-x1)
    // unsigned int sx = sgn_u16(x2-x1)
    lda.z sgn_u16.return
    sta.z sx
    lda.z sgn_u16.return+1
    sta.z sx+1
    // sgn_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    sta.z sgn_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // sgn_u16(y2-y1)
    // unsigned int sy = sgn_u16(y2-y1)
    // if(dx > dy)
    lda.z dy+1
    cmp.z dx+1
    bcc __b2
    bne !+
    lda.z dy
    cmp.z dx
    bcc __b2
  !:
    // unsigned int e = dx/2
    lda.z dx+1
    lsr
    sta.z e+1
    lda.z dx
    ror
    sta.z e
  __b6:
    // bitmap_plot(x,(char)y)
    ldx.z y
    jsr bitmap_plot
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e += dx
    lda.z e
    clc
    adc.z dx
    sta.z e
    lda.z e+1
    adc.z dx+1
    sta.z e+1
    // if(dy<e)
    cmp.z dy+1
    bne !+
    lda.z e
    cmp.z dy
    beq __b7
  !:
    bcc __b7
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e -= dy
    lda.z e
    sec
    sbc.z dy
    sta.z e
    lda.z e+1
    sbc.z dy+1
    sta.z e+1
  __b7:
    // while (y != y2)
    lda.z y+1
    cmp.z y2+1
    bne __b6
    lda.z y
    cmp.z y2
    bne __b6
  __b3:
    // bitmap_plot(x,(char)y)
    ldx.z y
    jsr bitmap_plot
    // }
    rts
  __b2:
    // unsigned int e = dy/2
    lda.z dy+1
    lsr
    sta.z e1+1
    lda.z dy
    ror
    sta.z e1
  __b9:
    // bitmap_plot(x,(char)y)
    ldx.z y
    jsr bitmap_plot
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e += dy
    lda.z e1
    clc
    adc.z dy
    sta.z e1
    lda.z e1+1
    adc.z dy+1
    sta.z e1+1
    // if(dx < e)
    cmp.z dx+1
    bne !+
    lda.z e1
    cmp.z dx
    beq __b10
  !:
    bcc __b10
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e -= dx
    lda.z e1
    sec
    sbc.z dx
    sta.z e1
    lda.z e1+1
    sbc.z dx+1
    sta.z e1+1
  __b10:
    // while (x != x2)
    lda.z x+1
    cmp.z x2+1
    bne __b9
    lda.z x
    cmp.z x2
    bne __b9
    jmp __b3
  __b4:
    // bitmap_plot(x,(char)y)
    ldx.z y1
    jsr bitmap_plot
    rts
}
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zp($a) w)
abs_u16: {
    .label w = $a
    .label return = $a
    // BYTE1(w)
    lda.z w+1
    // BYTE1(w)&0x80
    and #$80
    // if(BYTE1(w)&0x80)
    cmp #0
    bne __b1
    rts
  __b1:
    // return -w;
    sec
    lda #0
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
    // }
    rts
}
// Get the sign of a 16-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is
// sgn_u16(word zp($17) w)
sgn_u16: {
    .label w = $17
    .label return = $c
    // BYTE1(w)
    lda.z w+1
    // BYTE1(w)&0x80
    and #$80
    // if(BYTE1(w)&0x80)
    cmp #0
    bne __b1
    lda #<1
    sta.z return
    lda #>1
    sta.z return+1
    rts
  __b1:
    lda #<-1
    sta.z return
    sta.z return+1
    // }
    rts
}
// Plot a single dot in the bitmap
// bitmap_plot(word zp(4) x, byte register(X) y)
bitmap_plot: {
    .label __0 = $19
    .label plotter = $17
    .label x = 4
    // char* plotter = (char*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __0
    lda.z x+1
    and #>$fff8
    sta.z __0+1
    // plotter += ( x & $fff8 )
    lda.z plotter
    clc
    adc.z __0
    sta.z plotter
    lda.z plotter+1
    adc.z __0+1
    sta.z plotter+1
    // BYTE0(x)
    ldx.z x
    // *plotter |= bitmap_plot_bit[BYTE0(x)]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
.segment Data
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  lines_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28, $3c
  lines_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28, $a
