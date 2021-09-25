// Tests the simple bitmap plotter
// Plots a few lines using the bresenham line algorithm
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="bitmap-plot-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// $D011 Control Register #1  Bit#5: BMM Turn Bitmap Mode on/off
  .const VICII_BMM = $20
  /// $D011 Control Register #1  Bit#4: DEN Switch VIC-II output on/off
  .const VICII_DEN = $10
  /// $D011 Control Register #1  Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  .const VICII_RSEL = 8
  .const WHITE = 1
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  .label BITMAP = $2000
  .label SCREEN = $400
  .label COSTAB = SINTAB+$40
.segment Code
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label __13 = 6
    .label __14 = $16
    .label a = $1c
    .label i = $1b
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta D011
    // *D018 = toD018(SCREEN, BITMAP)
    lda #toD0181_return
    sta D018
    lda #0
    sta.z a
    sta.z i
  __b1:
    // for( byte i=0, a=0; i!=8; i++, a+=32)
    lda #8
    cmp.z i
    bne __b2
  __b3:
    // (*(SCREEN+999))++;
    inc SCREEN+$3e7
    jmp __b3
  __b2:
    // (word)COSTAB[a]+120
    ldy.z a
    lda COSTAB,y
    sta.z __13
    lda #0
    sta.z __13+1
    // bitmap_line( (word)COSTAB[a]+120, (word)SINTAB[a], (word)COSTAB[a+32]+120, (word)SINTAB[a+32])
    lda #$78
    clc
    adc.z bitmap_line.x1
    sta.z bitmap_line.x1
    bcc !+
    inc.z bitmap_line.x1+1
  !:
    // (word)COSTAB[a+32]+120
    ldy.z a
    lda COSTAB+$20,y
    sta.z __14
    lda #0
    sta.z __14+1
    // bitmap_line( (word)COSTAB[a]+120, (word)SINTAB[a], (word)COSTAB[a+32]+120, (word)SINTAB[a+32])
    lda #$78
    clc
    adc.z bitmap_line.x2
    sta.z bitmap_line.x2
    bcc !+
    inc.z bitmap_line.x2+1
  !:
    ldy.z a
    lda SINTAB,y
    sta.z bitmap_line.y1
    lda #0
    sta.z bitmap_line.y1+1
    lda SINTAB+$20,y
    sta.z bitmap_line.y2
    lda #0
    sta.z bitmap_line.y2+1
    jsr bitmap_line
    // a+=32
    lax.z a
    axs #-[$20]
    stx.z a
    // for( byte i=0, a=0; i!=8; i++, a+=32)
    inc.z i
    jmp __b1
}
// Initialize bitmap plotting tables
// void bitmap_init(char *gfx, char *screen)
bitmap_init: {
    .label __7 = $1a
    .label yoffs = $c
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
    lda.z yoffs
    clc
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
// void bitmap_clear(char bgcol, char fgcol)
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
// Draw a line on the bitmap using bresenhams algorithm
// void bitmap_line(__zp(6) unsigned int x1, __zp($a) unsigned int y1, __zp($16) unsigned int x2, __zp($18) unsigned int y2)
bitmap_line: {
    .label dx = $12
    .label dy = $e
    .label sx = $14
    .label sy = $10
    .label e1 = 8
    .label e = $c
    .label y = $a
    .label x = 6
    .label x1 = 6
    .label y1 = $a
    .label x2 = $16
    .label y2 = $18
    // unsigned int dx = abs_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    sta.z abs_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z abs_u16.w+1
    jsr abs_u16
    // unsigned int dx = abs_u16(x2-x1)
    lda.z abs_u16.return
    sta.z dx
    lda.z abs_u16.return+1
    sta.z dx+1
    // unsigned int dy = abs_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    sta.z abs_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z abs_u16.w+1
    jsr abs_u16
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
    // unsigned int sx = sgn_u16(x2-x1)
    lda.z x2
    sec
    sbc.z x1
    sta.z sgn_u16.w
    lda.z x2+1
    sbc.z x1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
    // unsigned int sx = sgn_u16(x2-x1)
    lda.z sgn_u16.return
    sta.z sx
    lda.z sgn_u16.return+1
    sta.z sx+1
    // unsigned int sy = sgn_u16(y2-y1)
    lda.z y2
    sec
    sbc.z y1
    sta.z sgn_u16.w
    lda.z y2+1
    sbc.z y1+1
    sta.z sgn_u16.w+1
    jsr sgn_u16
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
    // Y is the driver
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
    clc
    lda.z y
    adc.z sy
    sta.z y
    lda.z y+1
    adc.z sy+1
    sta.z y+1
    // e += dx
    clc
    lda.z e
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
    clc
    lda.z x
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
    // X is the driver
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
    clc
    lda.z x
    adc.z sx
    sta.z x
    lda.z x+1
    adc.z sx+1
    sta.z x+1
    // e += dy
    clc
    lda.z e1
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
    clc
    lda.z y
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp(8) void *str, __register(X) char c, __zp($a) unsigned int num)
memset: {
    .label end = $a
    .label dst = 8
    .label num = $a
    .label str = 8
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    clc
    lda.z end
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
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// __zp($e) unsigned int abs_u16(__zp($e) unsigned int w)
abs_u16: {
    .label w = $e
    .label return = $e
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
// __zp($10) unsigned int sgn_u16(__zp(2) unsigned int w)
sgn_u16: {
    .label w = 2
    .label return = $10
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
// void bitmap_plot(__zp(6) unsigned int x, __register(X) char y)
bitmap_plot: {
    .label __1 = 4
    .label plotter = 2
    .label x = 6
    // MAKEWORD( bitmap_plot_yhi[y], bitmap_plot_ylo[y] )
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __1
    lda.z x+1
    and #>$fff8
    sta.z __1+1
    // plotter += ( x & $fff8 )
    clc
    lda.z plotter
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
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
  .align $100
SINTAB:
.fill $180, 99.5+99.5*sin(i*2*PI/256) 
