// Check that division by factors of 2 is converted to shifts
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    txa
    lsr
    sta SCREEN,x
    txa
    lsr
    lsr
    sta SCREEN+$28,x
    txa
    lsr
    lsr
    lsr
    sta SCREEN+$50,x
    txa
    eor #$ff
    clc
    adc #1
    cmp #$80
    ror
    sta SCREEN+$a0,x
    inx
    cpx #$b
    bne b1
    rts
}
