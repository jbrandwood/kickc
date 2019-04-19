// Demonstrates a procedure reserving addresses on zeropage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label i = 8
    lda #0
    sta i
  b1:
    lda i
    jsr sub1
    ldy i
    sta SCREEN,y
    ldx i
    jsr sub2
    ldy i
    sta SCREEN+$28,y
    inc i
    lda #3
    cmp i
    bne b1
    rts
}
// sub2(byte register(X) i)
sub2: {
    txa
    asl
    stx $ff
    clc
    adc $ff
    rts
}
// sub1(byte register(A) i)
sub1: {
    asl
    rts
}
