// Demonstrates a procedure reserving addresses on zeropage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label i = 8
    lda #0
    sta.z i
  __b1:
    lda.z i
    jsr sub1
    ldy.z i
    sta SCREEN,y
    ldx.z i
    jsr sub2
    ldy.z i
    sta SCREEN+$28,y
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    rts
}
// sub2(byte register(X) i)
sub2: {
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    rts
}
// sub1(byte register(A) i)
sub1: {
    asl
    rts
}
