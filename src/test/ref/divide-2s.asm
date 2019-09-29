// Check that division by factors of 2 is converted to shifts
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    txa
    sta SCREEN,x
    txa
    lsr
    sta SCREEN+$28*1,x
    txa
    lsr
    lsr
    sta SCREEN+$28*2,x
    txa
    lsr
    lsr
    lsr
    sta SCREEN+$28*3,x
    txa
    eor #$ff
    clc
    adc #1
    cmp #$80
    ror
    sta SCREEN+$28*5,x
    inx
    cpx #$b
    bne __b1
    rts
}
