// Minimal test of mul8u
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label __0 = 4
    .label i = 3
    .label a = 2
    lda #0
    sta.z i
    sta.z a
  __b1:
    ldy #0
  __b2:
    ldx.z a
    tya
    jsr mul8u
    lda.z i
    asl
    tax
    lda.z __0
    sta screen,x
    lda.z __0+1
    sta screen+1,x
    inc.z i
    iny
    cpy #6
    bne __b2
    inc.z a
    lda #6
    cmp.z a
    bne __b1
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = 6
    .label res = 4
    .label return = 4
    sta.z mb
    lda #0
    sta.z mb+1
    sta.z res
    sta.z res+1
  __b1:
    cpx #0
    bne __b2
    rts
  __b2:
    txa
    and #1
    cmp #0
    beq __b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    txa
    lsr
    tax
    asl.z mb
    rol.z mb+1
    jmp __b1
}
