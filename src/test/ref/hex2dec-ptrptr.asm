// Testing binary to hex conversion using pointer to pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr cls
    lda #<$400
    sta.z utoa16w.dst
    lda #>$400
    sta.z utoa16w.dst+1
    lda #<0
    sta.z utoa16w.value
    sta.z utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28
    sta.z utoa16w.dst
    lda #>$400+$28
    sta.z utoa16w.dst+1
    lda #<$4d2
    sta.z utoa16w.value
    lda #>$4d2
    sta.z utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28
    sta.z utoa16w.dst+1
    lda #<$162e
    sta.z utoa16w.value
    lda #>$162e
    sta.z utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28+$28
    sta.z utoa16w.dst+1
    lda #<$270f
    sta.z utoa16w.value
    lda #>$270f
    sta.z utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28+$28+$28+$28
    sta.z utoa16w.dst
    lda #>$400+$28+$28+$28+$28
    sta.z utoa16w.dst+1
    lda #<$e608
    sta.z utoa16w.value
    lda #>$e608
    sta.z utoa16w.value+1
    jsr utoa16w
    rts
}
// Hexadecimal utoa() for an unsigned int (16bits)
// utoa16w(word zeropage(4) value, byte* zeropage(2) dst)
utoa16w: {
    .label dst = 2
    .label value = 4
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
    .label sc = 4
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
