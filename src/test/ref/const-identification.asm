.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label plots = $1000
  .label SCREEN = $400
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
  b3:
    jsr line
    jmp b3
}
line: {
    .const x0 = 0
    .const x1 = $a
    ldy #x0
  b5:
    jsr plot
    iny
    cpy #x1
    bcc b5
    beq b5
    rts
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
