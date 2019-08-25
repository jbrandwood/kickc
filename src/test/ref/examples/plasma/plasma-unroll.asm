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
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .const BLUE = 6
  .label print_line_cursor = $400
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  .label SCREEN1 = $2800
  .label CHARSET = $2000
  .label print_char_cursor = $c
  .label c1A = $b
  .label c1B = $f
  .label c2A = $12
  .label c2B = 2
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .label col = 9
    sei
    lda #BLUE
    sta BORDERCOL
    sta BGCOL
    lda #<COLS
    sta.z col
    lda #>COLS
    sta.z col+1
  b1:
    lda #BLACK
    ldy #0
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    lda.z col+1
    cmp #>COLS+$3e8+1
    bne b1
    lda.z col
    cmp #<COLS+$3e8+1
    bne b1
    jsr makecharset
    lda #toD0181_return
    sta D018
    lda #0
    sta.z c2B
    sta.z c2A
    sta.z c1B
    sta.z c1A
  b4:
    jsr doplasma
    jmp b4
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
    lda.z c1A
    sta.z c1a
    lda.z c1B
    sta.z c1b
    ldx #0
    txa
    sta.z i
  // Calculate ybuff as a bunch of differences
  b1:
    lda.z i
    cmp #$19
    bcs !b2+
    jmp b2
  !b2:
    lax.z c1A
    axs #-[3]
    stx.z c1A
    lax.z c1B
    axs #5
    stx.z c1B
    lda.z c2A
    sta.z c2a
    lda.z c2B
    sta.z c2b
    lda #0
    sta.z i1
  b4:
    lda.z i1
    cmp #$28
    bcs !b5+
    jmp b5
  !b5:
    lda.z c2A
    clc
    adc #2
    sta.z c2A
    lax.z c2B
    axs #3
    stx.z c2B
    ldx #0
  b7:
    cpx #$28
    bcc b8
    rts
  b8:
    // Find the first value on the row
    lda xbuf,x
    clc
    adc ybuf
    sta SCREEN1,x
    clc
    adc ybuf+1
    sta SCREEN1+1*$28,x
    clc
    adc ybuf+2
    sta SCREEN1+2*$28,x
    clc
    adc ybuf+3
    sta SCREEN1+3*$28,x
    clc
    adc ybuf+4
    sta SCREEN1+4*$28,x
    clc
    adc ybuf+5
    sta SCREEN1+5*$28,x
    clc
    adc ybuf+6
    sta SCREEN1+6*$28,x
    clc
    adc ybuf+7
    sta SCREEN1+7*$28,x
    clc
    adc ybuf+8
    sta SCREEN1+8*$28,x
    clc
    adc ybuf+9
    sta SCREEN1+9*$28,x
    clc
    adc ybuf+$a
    sta SCREEN1+$a*$28,x
    clc
    adc ybuf+$b
    sta SCREEN1+$b*$28,x
    clc
    adc ybuf+$c
    sta SCREEN1+$c*$28,x
    clc
    adc ybuf+$d
    sta SCREEN1+$d*$28,x
    clc
    adc ybuf+$e
    sta SCREEN1+$e*$28,x
    clc
    adc ybuf+$f
    sta SCREEN1+$f*$28,x
    clc
    adc ybuf+$10
    sta SCREEN1+$10*$28,x
    clc
    adc ybuf+$11
    sta SCREEN1+$11*$28,x
    clc
    adc ybuf+$12
    sta SCREEN1+$12*$28,x
    clc
    adc ybuf+$13
    sta SCREEN1+$13*$28,x
    clc
    adc ybuf+$14
    sta SCREEN1+$14*$28,x
    clc
    adc ybuf+$15
    sta SCREEN1+$15*$28,x
    clc
    adc ybuf+$16
    sta SCREEN1+$16*$28,x
    clc
    adc ybuf+$17
    sta SCREEN1+$17*$28,x
    clc
    adc ybuf+$18
    sta SCREEN1+$18*$28,x
    inx
    jmp b7
  b5:
    ldy.z c2a
    lda SINTABLE,y
    ldy.z c2b
    clc
    adc SINTABLE,y
    ldy.z i1
    sta xbuf,y
    lax.z c2a
    axs #-[3]
    stx.z c2a
    lax.z c2b
    axs #-[7]
    stx.z c2b
    inc.z i1
    jmp b4
  b2:
    ldy.z c1a
    lda SINTABLE,y
    ldy.z c1b
    clc
    adc SINTABLE,y
    sta.z yval
    txa
    eor #$ff
    sec
    adc.z yval
    ldy.z i
    sta ybuf,y
    lax.z c1a
    axs #-[4]
    stx.z c1a
    lax.z c1b
    axs #-[9]
    stx.z c1b
    inc.z i
    ldx.z yval
    jmp b1
    xbuf: .fill $28, 0
    ybuf: .fill $19, 0
}
// Make a plasma-friendly charset where the chars are randomly filled
makecharset: {
    .label _7 = $12
    .label _10 = $10
    .label _11 = $10
    .label s = $f
    .label i = $b
    .label c = 9
    .label _16 = $10
    jsr sid_rnd_init
    jsr print_cls
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
    sta.z print_char_cursor+1
    lda #<0
    sta.z c
    sta.z c+1
  b1:
    lda.z c+1
    cmp #>$100
    bcc b2
    bne !+
    lda.z c
    cmp #<$100
    bcc b2
  !:
    rts
  b2:
    lda.z c
    tay
    lda SINTABLE,y
    sta.z s
    lda #0
    sta.z i
  b3:
    lda.z i
    cmp #8
    bcc b4
    lda #7
    and.z c
    cmp #0
    bne b11
    jsr print_char
  b11:
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp b1
  b4:
    ldy #0
    ldx #0
  b5:
    cpx #8
    bcc b6
    lda.z c
    asl
    sta.z _10
    lda.z c+1
    rol
    sta.z _10+1
    asl.z _10
    rol.z _10+1
    asl.z _10
    rol.z _10+1
    lda.z i
    clc
    adc.z _11
    sta.z _11
    bcc !+
    inc.z _11+1
  !:
    clc
    lda.z _16
    adc #<CHARSET
    sta.z _16
    lda.z _16+1
    adc #>CHARSET
    sta.z _16+1
    tya
    ldy #0
    sta (_16),y
    inc.z i
    jmp b3
  b6:
    jsr sid_rnd
    and #$ff
    sta.z _7
    lda.z s
    cmp.z _7
    bcs b8
    tya
    ora bittab,x
    tay
  b8:
    inx
    jmp b5
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    lda SID_VOICE3_OSC
    rts
}
// Print a single char
print_char: {
    .const ch = '.'
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_line_cursor
    .label end = str+num
    .label dst = $c
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  b1:
    lda.z dst+1
    cmp #>end
    bne b2
    lda.z dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b1
}
// Initialize SID voice 3 for random number generation
sid_rnd_init: {
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    rts
}
  .align $100
SINTABLE:
.for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(toRadians(360*i/256)))

