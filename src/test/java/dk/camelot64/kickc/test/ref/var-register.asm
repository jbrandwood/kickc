.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label x = 2
    lda #0
    sta x
  b1:
    ldy #0
  b2:
    ldx #0
  b3:
    txa
    clc
    adc x
    jsr print
    inx
    cpx #$65
    bne b3
    iny
    cpy #$65
    bne b2
    inc x
    lda x
    cmp #$65
    bne b1
    rts
}
print: {
    .const SCREEN = $400
    sta SCREEN,y
    rts
}
