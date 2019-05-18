// Minimal test of mul8u
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label _0 = 4
    .label i = 3
    .label a = 2
    lda #0
    sta i
    sta a
  b1:
    ldy #0
  b2:
    ldx a
    tya
    jsr mul8u
    lda i
    asl
    tax
    lda _0
    sta screen,x
    lda _0+1
    sta screen+1,x
    inc i
    iny
    cpy #6
    bne b2
    inc a
    lda #6
    cmp a
    bne b1
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = 6
    .label res = 4
    .label return = 4
    sta mb
    lda #0
    sta mb+1
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b3:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
