.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const SCREEN2 = SCREEN+$28*3
  .const SCREEN3 = SCREEN+$28*6
  .const SCREEN4 = SCREEN+$28*9
  jsr main
main: {
    ldx #0
  b1:
    stx $ff
    lda #$c8
    sec
    sbc $ff
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
    clc
    adc #$578-$546
    tax
    lda #b
    sta SCREEN3,y
    txa
    sta SCREEN4,y
    iny
    cpy #$b
    bne b1
    rts
}
