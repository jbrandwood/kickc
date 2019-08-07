// Tests subtracting bytes from signed words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label w1 = 2
    ldx #0
    lda #<$4d2
    sta.z w1
    lda #>$4d2
    sta.z w1+1
  b1:
    lda.z w1
    sec
    sbc #$29
    sta.z w1
    lda.z w1+1
    sbc #>$29
    sta.z w1+1
    txa
    asl
    tay
    lda.z w1
    sta screen,y
    lda.z w1+1
    sta screen+1,y
    inx
    cpx #$b
    bne b1
    rts
}
