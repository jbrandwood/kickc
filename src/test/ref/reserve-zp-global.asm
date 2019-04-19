// Demonstrates global directive reserving addresses on zeropage
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label i = 6
    lda #0
    sta i
  b1:
    lda i
    jsr sub1
    ldy i
    sta SCREEN,y
    inc i
    lda #3
    cmp i
    bne b1
    rts
}
// sub1(byte register(A) i)
sub1: {
    asl
    rts
}
