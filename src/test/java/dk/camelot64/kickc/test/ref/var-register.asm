.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label y = 3
    .label x = 2
    lda #0
    sta x
  b1:
    lda #0
    sta y
  b2:
    ldx #0
  b3:
    txa
    clc
    adc x
    tay
    jsr print
    inx
    cpx #$65
    bne b3
    inc y
    lda y
    cmp #$65
    bne b2
    inc x
    lda x
    cmp #$65
    bne b1
    rts
}
print: {
    .const SCREEN = $400
    .label idx = 3
    tya
    ldy idx
    sta SCREEN,y
    rts
}
