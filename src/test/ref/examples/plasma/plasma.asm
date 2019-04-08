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
  .label SINTABLE = $1f00
  .label print_char_cursor = $b
  .label c1A = 4
  .label c1B = 5
  .label c2A = 6
  .label c2B = 7
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)<<2)|(>CHARSET)>>2&$f
    .const toD0182_return = (>(SCREEN2&$3fff)<<2)|(>CHARSET)>>2&$f
    .label col = 2
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
// doplasma(byte* zeropage(2) screen)
doplasma: {
    .label c1a = 8
    .label c1b = 9
    .label i = $a
    .label c2a = 8
    .label c2b = 9
    .label i1 = $a
    .label screen = 2
    lda c1A
    sta c1a
    lda c1B
    sta c1b
    lda #0
    sta i
  b1:
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
    bcc b1
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
  b3:
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
    bcc b3
    lda c2A
    clc
    adc #2
    sta c2A
    lax c2B
    axs #3
    stx c2B
    ldx #0
  b5:
    ldy #0
  b6:
    lda xbuf,y
    clc
    adc ybuf,x
    sta (screen),y
    iny
    cpy #$28
    bcc b6
    lda #$28
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    inx
    cpx #$19
    bcc b5
    rts
    xbuf: .fill $28, 0
    ybuf: .fill $19, 0
}
// Make a plasma-friendly charset where the chars are randomly filled
makecharset: {
    .label _4 = 6
    .label _8 = $d
    .label _9 = $d
    .label s = 5
    .label i = 4
    .label c = 2
    jsr sid_rnd_init
    jsr print_cls
    lda #<print_line_cursor
    sta print_char_cursor
    lda #>print_line_cursor
    sta print_char_cursor+1
    lda #0
    sta c
    sta c+1
  b1:
    lda c
    tay
    lda SINTABLE,y
    sta s
    lda #0
    sta i
  b2:
    ldy #0
    ldx #0
  b3:
    jsr sid_rnd
    and #$ff
    sta _4
    lda s
    cmp _4
    bcs b4
    tya
    ora bittab,x
    tay
  b4:
    inx
    cpx #8
    bcc b3
    lda c
    asl
    sta _8
    lda c+1
    rol
    sta _8+1
    asl _8
    rol _8+1
    asl _8
    rol _8+1
    lda i
    clc
    adc _9
    sta _9
    bcc !+
    inc _9+1
  !:
    tya
    sta !v++1
    lda #<CHARSET
    clc
    adc _9
    sta !a++1
    lda #>CHARSET
    adc _9+1
    sta !a++2
  !v:
    lda #0
  !a:
    sta CHARSET
    inc i
    lda i
    cmp #8
    bcc b2
    lda c
    and #7
    cmp #0
    bne b9
    jsr print_char
  b9:
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>$100
    bcc b1
    bne !+
    lda c
    cmp #<$100
    bcs !b1+
    jmp b1
  !b1:
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
    .label sc = 2
    lda #<print_line_cursor
    sta sc
    lda #>print_line_cursor
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>print_line_cursor+$3e8
    bne b1
    lda sc
    cmp #<print_line_cursor+$3e8
    bne b1
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
.pc = SINTABLE "SINTABLE"
  .for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(toRadians(360*i/256)))

