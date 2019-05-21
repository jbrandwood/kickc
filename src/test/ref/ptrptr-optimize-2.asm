// Tests (non-)optimization of constant pointers to pointers
// The two examples of &screen is not detected as identical leading to ASM that could be optimized more
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    lda #<screen
    sta sub.dst
    lda #>screen
    sta sub.dst+1
    ldx #'a'
    jsr sub
    lda #<screen
    sta sub.dst
    lda #>screen
    sta sub.dst+1
    ldx #'b'
    jsr sub
    rts
}
// sub(byte register(X) ch, byte** zeropage(2) dst)
sub: {
    .label dst = 2
    txa
    ldy dst
    sty !++1
    ldy #0
  !:
    sta ($ff),y
    ldy #0
    lda (dst),y
    clc
    adc #1
    sta (dst),y
    rts
}
