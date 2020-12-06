// Tests the simple bitmap plotter
// Plots a few lines using the bresenham line algorithm
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .const WHITE = 1
  .label D011 = $d011
  .label D018 = $d018
  .label BITMAP = $2000
  .label SCREEN = $400
  .label COSTAB = SINTAB+$40
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label __13 = 6
    .label __14 = $10
    .label a = 3
    .label i = 2
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
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
bitmap_init: {
    .label __7 = $14
    .label yoffs = 4
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
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
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
// Draw a line on the bitmap using bresenhams algorithm
// bitmap_line(word zp(6) x1, word zp(8) y1, word zp($10) x2, word zp($12) y2)
bitmap_line: {
    .label dx = $15
    .label dy = $c
    .label sx = $17
    .label sy = $e
    .label e1 = $a
    .label e = 4
    .label y = 8
    .label x = 6
    .label x1 = 6
    .label y1 = 8
    .label x2 = $10
    .label y2 = $12
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
    // dx = abs_u16(x2-x1)
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
    // dy = abs_u16(y2-y1)
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
    // sx = sgn_u16(x2-x1)
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
    // sy = sgn_u16(y2-y1)
    // if(dx > dy)
    lda.z dy+1
    cmp.z dx+1
    bcc __b2
    bne !+
    lda.z dy
    cmp.z dx
    bcc __b2
  !:
    // e = dx/2
    lda.z dx+1
    lsr
    sta.z e+1
    lda.z dx
    ror
    sta.z e
  __b6:
    // bitmap_plot(x,(char)y)
    lda.z y
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
    lda.z y
    jsr bitmap_plot
    // }
    rts
  __b2:
    // e = dy/2
    lda.z dy+1
    lsr
    sta.z e1+1
    lda.z dy
    ror
    sta.z e1
  __b9:
    // bitmap_plot(x,(char)y)
    lda.z y
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
    lda.z y1
    jsr bitmap_plot
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($a) str, byte register(X) c, word zp(8) num)
memset: {
    .label end = 8
    .label dst = $a
    .label num = 8
    .label str = $a
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
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
// Get the absolute value of a 16-bit unsigned number treated as a signed number.
// abs_u16(word zp($c) w)
abs_u16: {
    .label w = $c
    .label return = $c
    // >w
    lda.z w+1
    // >w&0x80
    and #$80
    // if(>w&0x80)
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
// sgn_u16(word zp($19) w)
sgn_u16: {
    .label w = $19
    .label return = $e
    // >w
    lda.z w+1
    // >w&0x80
    and #$80
    // if(>w&0x80)
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
// bitmap_plot(word zp(6) x, byte register(A) y)
bitmap_plot: {
    .label __0 = $1b
    .label plotter = $19
    .label x = 6
    // plotter = (char*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    tay
    lda bitmap_plot_yhi,y
    sta.z plotter+1
    lda bitmap_plot_ylo,y
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
    // <x
    ldx.z x
    // *plotter |= bitmap_plot_bit[<x]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  .align $100
SINTAB:
.fill $180, 99.5+99.5*sin(i*2*PI/256) 
