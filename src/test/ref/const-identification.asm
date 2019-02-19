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
  b2:
    jsr line
    jmp b2
}
line: {
    .const x0 = 0
    .const x1 = $a
    ldx #x0
  b3:
    jsr plot
    inx
    cpx #x1
    bcc b3
    beq b3
    rts
}
// plot(byte register(X) x)
plot: {
    ldy plots,x
    lda SCREEN,y
    clc
    adc #1
    sta SCREEN,y
    rts
}
