.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b1:
    txa
    sta bs,x
    inx
    cpx #0
    bne b1
    ldy #0
    ldx #$ff
  b2:
    lda bs,x
    sta cs,y
    dex
    iny
    cpy #0
    bne b2
    rts
    .align $100
    cs: .fill $100, 0
}
  .align $100
  bs: .fill $100, 0
