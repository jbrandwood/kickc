// A KickC version of the plasma routine from the CC65 samples
// This version has an unrolled inner loop to reach 50+FPS
// This version also optimizes the inner loop by calculating the Y buffer as a set of differences
// (w)2001 by groepaz/hitmen
// Cleanup and porting to CC65 by Ullrich von Bassewitz.
// Ported to KickC by Jesper Gravgaard.
// Original source https://github.com/cc65/cc65/blob/master/samples/plasma.c
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // SID Channel Control Register Noise Waveform
  .const SID_CONTROL_NOISE = $80
  // The colors of the C64
  .const BLACK = 0
  .const BLUE = 6
  .const OFFSET_STRUCT_MOS6581_SID_CH3_FREQ = $e
  .const OFFSET_STRUCT_MOS6581_SID_CH3_CONTROL = $12
  .const OFFSET_STRUCT_MOS6581_SID_CH3_OSC = $1b
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .label D018 = $d018
  // The SID MOS 6581/8580
  .label SID = $d400
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Color Ram
  .label COLS = $d800
  .label SCREEN1 = $2800
  .label CHARSET = $2000
  .label print_screen = $400
  .label print_char_cursor = $b
  // Plasma state variables
  .label c1A = $d
  .label c1B = $f
  .label c2A = $12
  .label c2B = 2
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .label col = $b
    // asm
    sei
    // VICII->BORDER_COLOR = BLUE
    lda #BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLUE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    lda #<COLS
    sta.z col
    lda #>COLS
    sta.z col+1
  __b1:
    // *col = BLACK
    lda #BLACK
    ldy #0
    sta (col),y
    // for(unsigned char* col : COLS..COLS+1000)
    inc.z col
    bne !+
    inc.z col+1
  !:
    lda.z col+1
    cmp #>COLS+$3e8+1
    bne __b1
    lda.z col
    cmp #<COLS+$3e8+1
    bne __b1
    // makecharset(CHARSET)
    jsr makecharset
    // *D018 = toD018(SCREEN1, CHARSET)
    lda #toD0181_return
    sta D018
    lda #0
    sta.z c2B
    sta.z c2A
    sta.z c1B
    sta.z c1A
  __b4:
    // doplasma(SCREEN1)
    // Show single-buffered plasma
    jsr doplasma
    jmp __b4
}
// Render plasma to the passed screen
doplasma: {
    .label c1a = 4
    .label c1b = 5
    .label yval = $e
    .label i = 3
    .label c2a = 7
    .label c2b = 8
    .label i1 = 6
    // c1a = c1A
    lda.z c1A
    sta.z c1a
    // c1b = c1B
    lda.z c1B
    sta.z c1b
    ldx #0
    txa
    sta.z i
  // Calculate ybuff as a bunch of differences
  __b1:
    // for (unsigned char i = 0; i < 25; ++i)
    lda.z i
    cmp #$19
    bcs !__b2+
    jmp __b2
  !__b2:
    // c1A += 3
    lax.z c1A
    axs #-[3]
    stx.z c1A
    // c1B -= 5
    lax.z c1B
    axs #5
    stx.z c1B
    // c2a = c2A
    lda.z c2A
    sta.z c2a
    // c2b = c2B
    lda.z c2B
    sta.z c2b
    lda #0
    sta.z i1
  __b4:
    // for (unsigned char i = 0; i < 40; ++i)
    lda.z i1
    cmp #$28
    bcs !__b5+
    jmp __b5
  !__b5:
    // c2A += 2
    lda.z c2A
    clc
    adc #2
    sta.z c2A
    // c2B -= 3
    lax.z c2B
    axs #3
    stx.z c2B
    ldx #0
  __b7:
    // for (unsigned char i = 0; i < 40; ++i)
    cpx #$28
    bcc __b8
    // }
    rts
  __b8:
    // val =  xbuf[i]
    // Find the first value on the row
    lda xbuf,x
    // val += ybuf[ii]
    clc
    adc ybuf
    // (screen+ii*40)[i] = val
    sta SCREEN1,x
    // val += ybuf[ii]
    clc
    adc ybuf+1
    // (screen+ii*40)[i] = val
    sta SCREEN1+1*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+2
    // (screen+ii*40)[i] = val
    sta SCREEN1+2*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+3
    // (screen+ii*40)[i] = val
    sta SCREEN1+3*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+4
    // (screen+ii*40)[i] = val
    sta SCREEN1+4*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+5
    // (screen+ii*40)[i] = val
    sta SCREEN1+5*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+6
    // (screen+ii*40)[i] = val
    sta SCREEN1+6*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+7
    // (screen+ii*40)[i] = val
    sta SCREEN1+7*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+8
    // (screen+ii*40)[i] = val
    sta SCREEN1+8*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+9
    // (screen+ii*40)[i] = val
    sta SCREEN1+9*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$a
    // (screen+ii*40)[i] = val
    sta SCREEN1+$a*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$b
    // (screen+ii*40)[i] = val
    sta SCREEN1+$b*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$c
    // (screen+ii*40)[i] = val
    sta SCREEN1+$c*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$d
    // (screen+ii*40)[i] = val
    sta SCREEN1+$d*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$e
    // (screen+ii*40)[i] = val
    sta SCREEN1+$e*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$f
    // (screen+ii*40)[i] = val
    sta SCREEN1+$f*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$10
    // (screen+ii*40)[i] = val
    sta SCREEN1+$10*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$11
    // (screen+ii*40)[i] = val
    sta SCREEN1+$11*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$12
    // (screen+ii*40)[i] = val
    sta SCREEN1+$12*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$13
    // (screen+ii*40)[i] = val
    sta SCREEN1+$13*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$14
    // (screen+ii*40)[i] = val
    sta SCREEN1+$14*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$15
    // (screen+ii*40)[i] = val
    sta SCREEN1+$15*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$16
    // (screen+ii*40)[i] = val
    sta SCREEN1+$16*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$17
    // (screen+ii*40)[i] = val
    sta SCREEN1+$17*$28,x
    // val += ybuf[ii]
    clc
    adc ybuf+$18
    // (screen+ii*40)[i] = val
    sta SCREEN1+$18*$28,x
    // for (unsigned char i = 0; i < 40; ++i)
    inx
    jmp __b7
  __b5:
    // SINTABLE[c2a] + SINTABLE[c2b]
    ldy.z c2a
    lda SINTABLE,y
    ldy.z c2b
    clc
    adc SINTABLE,y
    // xbuf[i] = (SINTABLE[c2a] + SINTABLE[c2b])
    ldy.z i1
    sta xbuf,y
    // c2a += 3
    lax.z c2a
    axs #-[3]
    stx.z c2a
    // c2b += 7
    lax.z c2b
    axs #-[7]
    stx.z c2b
    // for (unsigned char i = 0; i < 40; ++i)
    inc.z i1
    jmp __b4
  __b2:
    // SINTABLE[c1a] + SINTABLE[c1b]
    ldy.z c1a
    lda SINTABLE,y
    ldy.z c1b
    clc
    adc SINTABLE,y
    sta.z yval
    // yval - yprev
    txa
    eor #$ff
    sec
    adc.z yval
    // ybuf[i] = yval - yprev
    ldy.z i
    sta ybuf,y
    // c1a += 4
    lax.z c1a
    axs #-[4]
    stx.z c1a
    // c1b += 9
    lax.z c1b
    axs #-[9]
    stx.z c1b
    // for (unsigned char i = 0; i < 25; ++i)
    inc.z i
    ldx.z yval
    jmp __b1
    xbuf: .fill $28, 0
    ybuf: .fill $19, 0
}
// Make a plasma-friendly charset where the chars are randomly filled
makecharset: {
    .label __7 = $12
    .label __10 = $10
    .label __11 = $10
    .label s = $f
    .label i = $d
    .label c = 9
    .label __16 = $10
    // SID->CH3_FREQ = 0xffff
    lda #<$ffff
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH3_FREQ
    lda #>$ffff
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH3_FREQ+1
    // SID->CH3_CONTROL = SID_CONTROL_NOISE
    lda #SID_CONTROL_NOISE
    sta SID+OFFSET_STRUCT_MOS6581_SID_CH3_CONTROL
    // print_cls()
    jsr print_cls
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<0
    sta.z c
    sta.z c+1
  __b1:
    // for (unsigned int c = 0; c < 0x100; ++c)
    lda.z c+1
    cmp #>$100
    bcc __b2
    bne !+
    lda.z c
    cmp #<$100
    bcc __b2
  !:
    // }
    rts
  __b2:
    // <c
    ldx.z c
    // s = SINTABLE[<c]
    lda SINTABLE,x
    sta.z s
    lda #0
    sta.z i
  __b3:
    // for ( unsigned char i = 0; i < 8; ++i)
    lda.z i
    cmp #8
    bcc __b4
    // c & 0x07
    lda #7
    and.z c
    // if ((c & 0x07) == 0)
    cmp #0
    bne __b10
    // print_char('.')
    jsr print_char
  __b10:
    // for (unsigned int c = 0; c < 0x100; ++c)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
  __b4:
    ldy #0
    ldx #0
  __b5:
    // for (unsigned char ii = 0; ii < 8; ++ii)
    cpx #8
    bcc sid_rnd1
    // c*8
    lda.z c
    asl
    sta.z __10
    lda.z c+1
    rol
    sta.z __10+1
    asl.z __10
    rol.z __10+1
    asl.z __10
    rol.z __10+1
    // (c*8) + i
    lda.z i
    clc
    adc.z __11
    sta.z __11
    bcc !+
    inc.z __11+1
  !:
    // charset[(c*8) + i] = b
    clc
    lda.z __16
    adc #<CHARSET
    sta.z __16
    lda.z __16+1
    adc #>CHARSET
    sta.z __16+1
    tya
    ldy #0
    sta (__16),y
    // for ( unsigned char i = 0; i < 8; ++i)
    inc.z i
    jmp __b3
  sid_rnd1:
    // return SID->CH3_OSC;
    lda SID+OFFSET_STRUCT_MOS6581_SID_CH3_OSC
    // sid_rnd() & 0xFF
    and #$ff
    sta.z __7
    // if ((sid_rnd() & 0xFF) > s)
    lda.z s
    cmp.z __7
    bcs __b7
    // b |= bittab[ii]
    tya
    ora bittab,x
    tay
  __b7:
    // for (unsigned char ii = 0; ii < 8; ++ii)
    inx
    jmp __b5
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Print a single char
print_char: {
    .const ch = '.'
    // *(print_char_cursor++) = ch
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = $10
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
  .align $100
SINTABLE:
.for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(toRadians(360*i/256)))

