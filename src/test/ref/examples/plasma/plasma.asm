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
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  .label SCREEN1 = $2800
  .label SCREEN2 = $2c00
  .label CHARSET = $2000
  .label print_line_cursor = $400
  .label print_char_cursor = 9
  .label c1A = $b
  .label c1B = $e
  .label c2A = $11
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
    sta.z col
    lda #>COLS
    sta.z col+1
  __b1:
    lda #BLACK
    ldy #0
    sta (col),y
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
    jsr makecharset
    lda #0
    sta.z c2B
    sta.z c2A
    sta.z c1B
    sta.z c1A
  // Show double-buffered plasma
  __b4:
    lda #<SCREEN1
    sta.z doplasma.screen
    lda #>SCREEN1
    sta.z doplasma.screen+1
    jsr doplasma
    lda #toD0181_return
    sta D018
    lda #<SCREEN2
    sta.z doplasma.screen
    lda #>SCREEN2
    sta.z doplasma.screen+1
    jsr doplasma
    lda #toD0182_return
    sta D018
    jmp __b4
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
    lda.z c1A
    sta.z c1a
    lda.z c1B
    sta.z c1b
    lda #0
    sta.z i
  __b1:
    lda.z i
    cmp #$19
    bcc __b2
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
  __b4:
    lda.z i1
    cmp #$28
    bcc __b5
    lda.z c2A
    clc
    adc #2
    sta.z c2A
    lax.z c2B
    axs #3
    stx.z c2B
    ldx #0
  __b7:
    cpx #$19
    bcc b1
    rts
  b1:
    ldy #0
  __b8:
    cpy #$28
    bcc __b9
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    inx
    jmp __b7
  __b9:
    lda xbuf,y
    clc
    adc ybuf,x
    sta (screen),y
    iny
    jmp __b8
  __b5:
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
    jmp __b4
  __b2:
    ldy.z c1a
    lda SINTABLE,y
    ldy.z c1b
    clc
    adc SINTABLE,y
    ldy.z i
    sta ybuf,y
    lax.z c1a
    axs #-[4]
    stx.z c1a
    lax.z c1b
    axs #-[9]
    stx.z c1b
    inc.z i
    jmp __b1
    xbuf: .fill $28, 0
    ybuf: .fill $19, 0
}
// Make a plasma-friendly charset where the chars are randomly filled
makecharset: {
    .label __7 = $11
    .label __10 = $f
    .label __11 = $f
    .label s = $e
    .label i = $b
    .label c = $c
    .label __16 = $f
    jsr sid_rnd_init
    jsr print_cls
    lda #<print_line_cursor
    sta.z print_char_cursor
    lda #>print_line_cursor
    sta.z print_char_cursor+1
    lda #<0
    sta.z c
    sta.z c+1
  __b1:
    lda.z c+1
    cmp #>$100
    bcc __b2
    bne !+
    lda.z c
    cmp #<$100
    bcc __b2
  !:
    rts
  __b2:
    lda.z c
    tay
    lda SINTABLE,y
    sta.z s
    lda #0
    sta.z i
  __b3:
    lda.z i
    cmp #8
    bcc b1
    lda #7
    and.z c
    cmp #0
    bne __b11
    jsr print_char
  __b11:
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
  b1:
    ldy #0
    ldx #0
  __b5:
    cpx #8
    bcc __b6
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
    lda.z i
    clc
    adc.z __11
    sta.z __11
    bcc !+
    inc.z __11+1
  !:
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
    inc.z i
    jmp __b3
  __b6:
    jsr sid_rnd
    and #$ff
    sta.z __7
    lda.z s
    cmp.z __7
    bcs __b8
    tya
    ora bittab,x
    tay
  __b8:
    inx
    jmp __b5
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
  __b1:
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    rts
  __b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
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

