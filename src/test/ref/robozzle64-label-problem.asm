.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label z1 = 5
    .label screen = 3
    .label z2 = 5
    .label y = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #0
    sta.z y
  __b1:
    ldx.z y
    jsr mul8u
    ldy #0
    lda.z z1
    sta (screen),y
    iny
    lda.z z1+1
    sta (screen),y
    ldx.z y
    jsr mul8u
    ldy #SIZEOF_WORD
    lda.z z2
    sta (screen),y
    iny
    lda.z z2+1
    sta (screen),y
    lda #SIZEOF_WORD+SIZEOF_WORD
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    inc.z y
    lda #6
    cmp.z y
    bne __b1
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .label mb = 7
    .label res = 5
    .label return = 5
    lda #<$28
    sta.z mb
    lda #>$28
    sta.z mb+1
    lda #<0
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
