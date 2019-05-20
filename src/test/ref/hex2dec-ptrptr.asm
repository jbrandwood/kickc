// Testing binary to hex conversion using pointer to pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr cls
    lda #<$400
    sta utoa16w.dst
    lda #>$400
    sta utoa16w.dst+1
    lda #0
    sta utoa16w.value
    sta utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28
    sta utoa16w.dst
    lda #>$400+$28
    sta utoa16w.dst+1
    lda #<$4d2
    sta utoa16w.value
    lda #>$4d2
    sta utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28+$28
    sta utoa16w.dst
    lda #>$400+$28+$28
    sta utoa16w.dst+1
    lda #<$162e
    sta utoa16w.value
    lda #>$162e
    sta utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28+$28+$28
    sta utoa16w.dst
    lda #>$400+$28+$28+$28
    sta utoa16w.dst+1
    lda #<$270f
    sta utoa16w.value
    lda #>$270f
    sta utoa16w.value+1
    jsr utoa16w
    lda #<$400+$28+$28+$28+$28
    sta utoa16w.dst
    lda #>$400+$28+$28+$28+$28
    sta utoa16w.dst+1
    lda #<$e608
    sta utoa16w.value
    lda #>$e608
    sta utoa16w.value+1
    jsr utoa16w
    rts
}
// Hexadecimal utoa() for an unsigned int (16bits)
// utoa16w(word zeropage(2) value, byte* zeropage(4) dst)
utoa16w: {
    .label value = 2
    .label dst = 4
    lda value+1
    lsr
    lsr
    lsr
    lsr
    tax
    lda #<dst
    sta utoa16n.dst
    lda #>dst
    sta utoa16n.dst+1
    lda #0
    sta utoa16n.started
    jsr utoa16n
    lda utoa16n.return
    tay
    lda value+1
    ldx #$f
    axs #0
    sty utoa16n.started
    lda #<dst
    sta utoa16n.dst
    lda #>dst
    sta utoa16n.dst+1
    jsr utoa16n
    lda utoa16n.return
    tay
    lda value
    lsr
    lsr
    lsr
    lsr
    tax
    sty utoa16n.started
    lda #<dst
    sta utoa16n.dst
    lda #>dst
    sta utoa16n.dst+1
    jsr utoa16n
    lda value
    ldx #$f
    axs #0
    lda #<dst
    sta utoa16n.dst
    lda #>dst
    sta utoa16n.dst+1
    lda #1
    sta utoa16n.started
    jsr utoa16n
    lda #0
    tay
    sta (dst),y
    rts
}
// Hexadecimal utoa() for a single nybble
// utoa16n(byte register(X) nybble, word** zeropage(6) dst, byte zeropage(8) started)
utoa16n: {
    .label started = 8
    .label return = 8
    .label dst = 6
    cpx #0
    beq b1
    lda #1
    sta return
  b1:
    lda return
    cmp #0
    beq breturn
    ldy #0
    lda dst
    sta !++1
    lda DIGITS,x
  !:
    sta (dst),y
    ldy #0
    lda (dst),y
    clc
    adc #1
    sta (dst),y
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
