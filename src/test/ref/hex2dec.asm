// Testing hex to decimal conversion
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label control = $d011
  .label raster = $d012
  .label bordercol = $d020
  .label utoa16_dst = 2
  .label utoa16_started = 4
main: {
    .label _1 = 4
    .label time_start = 5
    sei
    jsr cls
  b1:
    lda #$80
    and control
    sta _1
    lda raster
    lsr
    ora _1
    cmp #$30
    bne b1
    lda #1
    sta bordercol
    lda raster
    sta time_start
    lda #0
    sta utoa16w.value
    sta utoa16w.value+1
    lda #<$400
    sta utoa16w.dst
    lda #>$400
    sta utoa16w.dst+1
    jsr utoa16w
    inc bordercol
    lda #<$4d2
    sta utoa16w.value
    lda #>$4d2
    sta utoa16w.value+1
    lda #<$400+$28
    sta utoa16w.dst
    lda #>$400+$28
    sta utoa16w.dst+1
    jsr utoa16w
    inc bordercol
    lda #<$162e
    sta utoa16w.value
    lda #>$162e
    sta utoa16w.value+1
    lda #<$400+$28+$28
    sta utoa16w.dst
    lda #>$400+$28+$28
    sta utoa16w.dst+1
    jsr utoa16w
    inc bordercol
    lda #<$270f
    sta utoa16w.value
    lda #>$270f
    sta utoa16w.value+1
    lda #<$400+$28+$28+$28
    sta utoa16w.dst
    lda #>$400+$28+$28+$28
    sta utoa16w.dst+1
    jsr utoa16w
    inc bordercol
    lda #<$e608
    sta utoa16w.value
    lda #>$e608
    sta utoa16w.value+1
    lda #<$400+$28+$28+$28+$28
    sta utoa16w.dst
    lda #>$400+$28+$28+$28+$28
    sta utoa16w.dst+1
    jsr utoa16w
    ldx raster
    lda #0
    sta bordercol
    txa
    sec
    sbc time_start
    sta utoa10w.value
    lda #0
    sta utoa10w.value+1
    jsr utoa10w
    ldx #0
  b3:
    lda msg,x
    sta $400+$28+$28+$28+$28+$50+3,x
    inx
    lda msg,x
    cmp #0
    bne b3
    jmp b1
    msg: .text "raster lines@"
}
// Decimal utoa() without using multiply or divide
// utoa10w(word zeropage(2) value, byte* zeropage(6) dst)
utoa10w: {
    .label value = 2
    .label digit = 4
    .label dst = 6
    .label bStarted = 5
    lda #<$400+$28+$28+$28+$28+$50
    sta dst
    lda #>$400+$28+$28+$28+$28+$50
    sta dst+1
    lda #0
    sta bStarted
    sta digit
    tax
  b1:
    txa
    asl
    tay
    lda UTOA10_SUB+1,y
    cmp value+1
    bne !+
    lda UTOA10_SUB,y
    cmp value
    beq b2
  !:
    bcc b2
    txa
    and #1
    cmp #0
    beq b6
    lda bStarted
    cmp #0
    beq b7
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
  b7:
    lda #0
    sta digit
  b6:
    inx
    cpx #8
    bne b1
    lda value
    tay
    lda DIGITS,y
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda #0
    tay
    sta (dst),y
    rts
  b2:
    lda UTOA10_VAL,x
    clc
    adc digit
    sta digit
    txa
    asl
    tay
    sec
    lda value
    sbc UTOA10_SUB,y
    sta value
    lda value+1
    sbc UTOA10_SUB+1,y
    sta value+1
    lda #1
    sta bStarted
    jmp b1
}
// Hexadecimal utoa() for an unsigned int (16bits)
// utoa16w(word zeropage(6) value, byte* zeropage(2) dst)
utoa16w: {
    .label dst = 2
    .label value = 6
    lda value+1
    lsr
    lsr
    lsr
    lsr
    tax
    lda #0
    sta utoa16_started
    jsr utoa16n
    lda value+1
    ldx #$f
    axs #0
    jsr utoa16n
    lda value
    lsr
    lsr
    lsr
    lsr
    tax
    jsr utoa16n
    lda value
    ldx #$f
    axs #0
    lda #1
    sta utoa16_started
    jsr utoa16n
    lda #0
    tay
    sta (utoa16_dst),y
    rts
}
// Hexadecimal utoa() for a single nybble
// utoa16n(byte register(X) nybble)
utoa16n: {
    cpx #0
    beq b1
    lda #1
    sta utoa16_started
  b1:
    lda utoa16_started
    cmp #0
    beq breturn
    lda DIGITS,x
    ldy #0
    sta (utoa16_dst),y
    inc utoa16_dst
    bne !+
    inc utoa16_dst+1
  !:
  breturn:
    rts
}
cls: {
    .label screen = $400
    .label sc = 2
    lda #<screen
    sta sc
    lda #>screen
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
    cmp #>screen+$3e7+1
    bne b1
    lda sc
    cmp #<screen+$3e7+1
    bne b1
    rts
}
  // Digits used for utoa()
  DIGITS: .text "0123456789abcdef@"
  // Subtraction values used for decimal utoa()
  UTOA10_SUB: .word $7530, $2710, $bb8, $3e8, $12c, $64, $1e, $a
  // Digit addition values used for decimal utoa()
  UTOA10_VAL: .byte 3, 1, 3, 1, 3, 1, 3, 1
