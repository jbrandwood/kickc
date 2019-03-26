.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label bp = b
    .label b = 2
    lda #0
    sta b
  b1:
    lda bp
    clc
    adc #1
    ldy b
    sta SCREEN,y
    inc b
    lda #$b
    cmp b
    bne b1
    rts
}
