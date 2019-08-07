// Test KickC performance for 16-bit array lookup function from article "Optimizing C array lookups for the 6502"
// http://8bitworkshop.com/blog/compilers/2019/03/17/cc65-optimization.html
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label _0 = 4
    ldx #0
  b1:
    txa
    sta.z getValue.index
    lda #0
    sta.z getValue.index+1
    jsr getValue
    txa
    asl
    tay
    lda.z _0
    sta SCREEN,y
    lda.z _0+1
    sta SCREEN+1,y
    inx
    cpx #$81
    bne b1
    rts
}
// getValue(word zeropage(2) index)
getValue: {
    .label index = 2
    .label return = 4
    lda.z index
    and #$7f
    asl
    tay
    lda #$ff
    and arr16,y
    lsr
    sta.z return
    lda #0
    sta.z return+1
    rts
}
  arr16: .fill 2*$80, 0
