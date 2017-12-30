.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
}
line: {
    .const x0 = 0
    .const x1 = $a
    .label x = 2
    lda #x0
    cmp #x1
    bcs b1
    sta x
  b2:
    ldx x
    jsr plot
    inc x
    lda x
    cmp #x1
    bcc b2
    beq b2
  breturn:
    rts
  b1:
    ldx #x0
    jsr plot
    jmp breturn
}
plot: {
    ldy plots,x
    lda SCREEN,y
    clc
    adc #1
    sta SCREEN,y
    rts
}
