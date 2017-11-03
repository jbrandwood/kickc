  .const plots = $1000
  .const SCREEN = $400
  jsr main
main: {
    ldx #0
  b1:
    txa
    sta plots,x
    lda #0
    sta SCREEN,x
    inx
    cpx #$28
    bne b1
  b2:
    jsr line
    jmp b2
    rts
}
line: {
    .const x1 = $a
    .label x = 2
    lda #0
    cmp #x1
    bcs b1
    sta x
  b2:
    ldy x
    jsr plot
    inc x
    lda x
    cmp #x1
    bcc b2
    beq b2
  breturn:
    rts
  b1:
    ldy #0
    jsr plot
    jmp breturn
}
plot: {
    ldx plots,y
    lda SCREEN,x
    clc
    adc #1
    sta SCREEN,x
    rts
}
