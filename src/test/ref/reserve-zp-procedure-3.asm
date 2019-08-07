// Demonstrates a procedure reserving addresses on zeropage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label i = 5
    lda #0
    sta.z i
  b1:
    lda.z i
    jsr sub1
    ldy.z i
    sta SCREEN,y
    inc.z i
    lda #3
    cmp.z i
    bne b1
    rts
}
// sub1(byte register(A) i)
sub1: {
    asl
    rts
}
