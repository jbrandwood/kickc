.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = SCREEN+$28*3
  .label SCREEN3 = SCREEN+$28*6
  .label SCREEN4 = SCREEN+$28*9
main: {
    ldx #0
  b1:
    txa
    eor #$ff
    clc
    adc #$c8+1
    sta SCREEN,x
    txa
    eor #$ff
    clc
    adc #1
    sta SCREEN2,x
    inx
    cpx #$65
    bne b1
    jsr w
    rts
}
w: {
    .const w1 = $514
    .const w2 = $4e2
    .const b = w1-w2
    ldy #0
  b1:
    tya
    tax
    axs #-$578-$546
    lda #b
    sta SCREEN3,y
    txa
    sta SCREEN4,y
    iny
    cpy #$b
    bne b1
    rts
}
