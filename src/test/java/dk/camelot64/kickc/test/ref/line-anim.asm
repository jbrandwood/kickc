.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    ldx #0
  b1:
    jsr init
    inx
    inx
    cpx #8
    bne b1
    rts
}
init: {
    .label _0 = 2
    .label _2 = 2
    .label _3 = 2
    lda x_start,x
    sta _0
    lda x_start+1,x
    sta _0+1
    asl _0
    rol _0+1
    asl _0
    rol _0+1
    asl _0
    rol _0+1
    asl _0
    rol _0+1
    lda _0
    sta x_cur,x
    lda _0+1
    sta x_cur+1,x
    txa
    lsr
    tay
    lda y_start,y
    sta _2
    lda #0
    sta _2+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    lda _3
    sta y_cur,x
    lda _3+1
    sta y_cur+1,x
    rts
}
  x_start: .word $a, $14, $1e, $1e
  y_start: .byte $a, $a, $a, $14
  x_cur: .fill 8, 0
  y_cur: .fill 8, 0
