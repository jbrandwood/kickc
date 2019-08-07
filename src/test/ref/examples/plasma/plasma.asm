// A KickC version of the plasma routine from the CC65 samples
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
  .label SCREEN2 = $2c00
  .label CHARSET = $2000
  .label print_char_cursor = 9
  .label c1A = $b
  .label c1B = $e
  .label c2A = $f
  .label c2B = 2
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN2&$3fff)*4)|(>CHARSET)/4&$f
    .label col = 9
    sei
    lda #BLUE
    sta BORDERCOL
    sta BGCOL
    lda #<COLS
    sta col
    lda #>COLS
    sta col+1
  b1:
    lda #BLACK
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    lda col+1
    cmp #>COLS+$3e8+1
    bne b1
    lda col
    cmp #<COLS+$3e8+1
    bne b1
    jsr makecharset
    lda #0
    sta c2B
    sta c2A
    sta c1B
    sta c1A
  // Show double-buffered plasma
  b4:
    lda #<SCREEN1
    sta doplasma.screen
    lda #>SCREEN1
    sta doplasma.screen+1
    jsr doplasma
    lda #toD0181_return
    sta D018
    lda #<SCREEN2
    sta doplasma.screen
    lda #>SCREEN2
    sta doplasma.screen+1
    jsr doplasma
    lda #toD0182_return
    sta D018
    jmp b4
}
// Render plasma to the passed screen
// doplasma(byte* zeropage(9) screen)
doplasma: {
    .label c1a = 4
    .label c1b = 5
    .label i = 3
    .label c2a = 7
    .label c2b = 8
    .label i1 = 6
    .label screen = 9
    lda c1A
    sta c1a
    lda c1B
    sta c1b
    lda #0
    sta i
  b2:
    ldy c1a
    lda SINTABLE,y
    ldy c1b
    clc
    adc SINTABLE,y
    ldy i
    sta ybuf,y
    lax c1a
    axs #-[4]
    stx c1a
    lax c1b
    axs #-[9]
    stx c1b
    inc i
    lda i
    cmp #$19
    bcc b2
    lax c1A
    axs #-[3]
    stx c1A
    lax c1B
    axs #5
    stx c1B
    lda c2A
    sta c2a
    lda c2B
    sta c2b
    lda #0
    sta i1
  b5:
    ldy c2a
    lda SINTABLE,y
    ldy c2b
    clc
    adc SINTABLE,y
    ldy i1
    sta xbuf,y
    lax c2a
    axs #-[3]
    stx c2a
    lax c2b
    axs #-[7]
    stx c2b
    inc i1
    lda i1
    cmp #$28
    bcc b5
    lda c2A
    clc
    adc #2
    sta c2A
    lax c2B
    axs #3
    stx c2B
    ldx #0
  b8:
    ldy #0
  b10:
    lda xbuf,y
    clc
    adc ybuf,x
    sta (screen),y
    iny
    cpy #$28
    bcc b10
    lda #$28
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    inx
    cpx #$19
    bcc b8
    rts
    xbuf: .fill $28, 0
    ybuf: .fill $19, 0
}
// Make a plasma-friendly charset where the chars are randomly filled
makecharset: {
    .label _7 = $f
    .label _10 = $10
    .label _11 = $10
    .label s = $e
    .label i = $b
    .label c = $c
    .label _16 = $10
    jsr sid_rnd_init
    jsr print_cls
    lda #<print_line_cursor
    sta print_char_cursor
    lda #>print_line_cursor
    sta print_char_cursor+1
    lda #<0
    sta c
    sta c+1
  b2:
    lda c
    tay
    lda SINTABLE,y
    sta s
    lda #0
    sta i
  b4:
    ldy #0
    ldx #0
  b7:
    jsr sid_rnd
    and #$ff
    sta _7
    lda s
    cmp _7
    bcs b9
    tya
    ora bittab,x
    tay
  b9:
    inx
    cpx #8
    bcc b7
    lda c
    asl
    sta _10
    lda c+1
    rol
    sta _10+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    lda i
    clc
    adc _11
    sta _11
    bcc !+
    inc _11+1
  !:
    clc
    lda _16
    adc #<CHARSET
    sta _16
    lda _16+1
    adc #>CHARSET
    sta _16+1
    tya
    ldy #0
    sta (_16),y
    inc i
    lda i
    cmp #8
    bcc b4
    lda c
    and #7
    cmp #0
    bne b12
    jsr print_char
  b12:
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>$100
    bcc b2
    bne !+
    lda c
    cmp #<$100
    bcc b2
  !:
    rts
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Print a single char
print_char: {
    .const ch = '.'
    lda #ch
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    lda SID_VOICE3_OSC
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
    sta dst
    lda #>str
    sta dst+1
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
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
        .byte round(127.5+127.5*sin(2*PI*i/256))

