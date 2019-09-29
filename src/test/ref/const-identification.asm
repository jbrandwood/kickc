.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label plots = $1000
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    txa
    sta plots,x
    lda #0
    sta SCREEN,x
    inx
    cpx #$28
    bne __b1
  __b2:
    jsr line
    jmp __b2
}
line: {
    .const x0 = 0
    .const x1 = $a
    ldy #x0
  __b1:
    cpy #x1+1
    bcc __b2
    rts
  __b2:
    jsr plot
    iny
    jmp __b1
}
// plot(byte register(Y) x)
plot: {
    ldx plots,y
    lda SCREEN,x
    clc
    adc #1
    sta SCREEN,x
    rts
}
