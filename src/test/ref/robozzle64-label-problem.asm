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
    sta screen
    lda #>$400
    sta screen+1
    lda #0
    sta y
  b1:
    ldx y
    lda #<mul8u.b
    sta mul8u.mb
    lda #>mul8u.b
    sta mul8u.mb+1
    jsr mul8u
    ldy #0
    lda z1
    sta (screen),y
    iny
    lda z1+1
    sta (screen),y
    ldx y
    lda #<mul8u.b
    sta mul8u.mb
    lda #>mul8u.b
    sta mul8u.mb+1
    jsr mul8u
    ldy #SIZEOF_WORD
    lda z2
    sta (screen),y
    iny
    lda z2+1
    sta (screen),y
    lda #SIZEOF_WORD+SIZEOF_WORD
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    inc y
    lda #6
    cmp y
    bne b1
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .label b = $28
    .label mb = 7
    .label res = 5
    .label return = 5
    lda #<0
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
