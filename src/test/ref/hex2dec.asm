// Testing hex to decimal conversion
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label control = $d011
  .label raster = $d012
  .label bordercol = $d020
main: {
    .label __1 = 8
    .label time_start = 9
    sei
    jsr cls
  __b1:
    lda #$80
    and control
    sta.z __1
    lda raster
    lsr
    ora.z __1
    cmp #$30
    bne __b1
    lda #1
    sta bordercol
    lda raster
    sta.z time_start
    lda #<$400
    sta.z utoa16w.dst
    lda #>$400
    sta.z utoa16w.dst+1
    lda #<0
    sta.z utoa16w.value
    sta.z utoa16w.value+1
    jsr utoa16w
    inc bordercol
    lda #<$400+$28
    sta.z utoa16w.dst
    lda #>$400+$28
    sta.z utoa16w.dst+1
    lda #<$4d2
    sta.z utoa16w.value
    lda #>$4d2
    sta.z utoa16w.value+1
    jsr utoa16w
    inc bordercol
    lda #<$400+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28
    sta.z utoa16w.dst+1
    lda #<$162e
    sta.z utoa16w.value
    lda #>$162e
    sta.z utoa16w.value+1
    jsr utoa16w
    inc bordercol
    lda #<$400+$28+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28+$28
    sta.z utoa16w.dst+1
    lda #<$270f
    sta.z utoa16w.value
    lda #>$270f
    sta.z utoa16w.value+1
    jsr utoa16w
    inc bordercol
    lda #<$400+$28+$28+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28+$28+$28
    sta.z utoa16w.dst+1
    lda #<$e608
    sta.z utoa16w.value
    lda #>$e608
    sta.z utoa16w.value+1
    jsr utoa16w
    ldx raster
    lda #0
    sta bordercol
    txa
    sec
    sbc.z time_start
    sta.z utoa10w.value
    lda #0
    sta.z utoa10w.value+1
    jsr utoa10w
    ldx #0
  __b3:
    lda msg,x
    cmp #0
    bne __b4
    jmp __b1
  __b4:
    lda msg,x
    sta $400+$28+$28+$28+$28+$50+3,x
    inx
    jmp __b3
    msg: .text "raster lines"
    .byte 0
}
// Decimal utoa() without using multiply or divide
// utoa10w(word zeropage(2) value, byte* zeropage(6) dst)
utoa10w: {
    .label value = 2
    .label digit = 8
    .label dst = 6
    .label bStarted = 9
    lda #<$400+$28+$28+$28+$28+$50
    sta.z dst
    lda #>$400+$28+$28+$28+$28+$50
    sta.z dst+1
    lda #0
    sta.z bStarted
    sta.z digit
    tax
  __b1:
    txa
    asl
    tay
    lda UTOA10_SUB+1,y
    cmp.z value+1
    bne !+
    lda UTOA10_SUB,y
    cmp.z value
    beq __b2
  !:
    bcc __b2
    txa
    and #1
    cmp #0
    beq __b6
    lda.z bStarted
    cmp #0
    beq __b7
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
  __b7:
    lda #0
    sta.z digit
  __b6:
    inx
    cpx #8
    bne __b1
    lda.z value
    tay
    lda DIGITS,y
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    lda #0
    tay
    sta (dst),y
    rts
  __b2:
    lda UTOA10_VAL,x
    clc
    adc.z digit
    sta.z digit
    txa
    asl
    tay
    sec
    lda.z value
    sbc UTOA10_SUB,y
    sta.z value
    lda.z value+1
    sbc UTOA10_SUB+1,y
    sta.z value+1
    lda #1
    sta.z bStarted
    jmp __b1
}
// Hexadecimal utoa() for an unsigned int (16bits)
// utoa16w(word zeropage(2) value, byte* zeropage(4) dst)
utoa16w: {
    .label dst = 4
    .label value = 2
    lda.z value+1
    lsr
    lsr
    lsr
    lsr
    ldx #0
    jsr utoa16n
    lda.z value+1
    and #$f
    jsr utoa16n
    lda.z value
    lsr
    lsr
    lsr
    lsr
    jsr utoa16n
    lda.z value
    and #$f
    ldx #1
    jsr utoa16n
    lda #0
    tay
    sta (dst),y
    rts
}
// Hexadecimal utoa() for a single nybble
// utoa16n(byte register(A) nybble, byte register(X) started)
utoa16n: {
    cmp #0
    beq __b1
    ldx #1
  __b1:
    cpx #0
    beq __breturn
    tay
    lda DIGITS,y
    ldy.z utoa16w.dst
    sty.z $fe
    ldy.z utoa16w.dst+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    inc.z utoa16w.dst
    bne !+
    inc.z utoa16w.dst+1
  !:
  __breturn:
    rts
}
cls: {
    .label screen = $400
    .label sc = 6
    lda #<screen
    sta.z sc
    lda #>screen
    sta.z sc+1
  __b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>screen+$3e7+1
    bne __b1
    lda.z sc
    cmp #<screen+$3e7+1
    bne __b1
    rts
}
  // Digits used for utoa()
  DIGITS: .text "0123456789abcdef"
  .byte 0
  // Subtraction values used for decimal utoa()
  UTOA10_SUB: .word $7530, $2710, $bb8, $3e8, $12c, $64, $1e, $a
  // Digit addition values used for decimal utoa()
  UTOA10_VAL: .byte 3, 1, 3, 1, 3, 1, 3, 1
