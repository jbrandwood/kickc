// Check that multiplication by factors of 2 is converted to shifts
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    txa
    asl
    sta SCREEN,x
    txa
    asl
    asl
    sta SCREEN+$28,x
    txa
    asl
    asl
    asl
    sta SCREEN+$50,x
    txa
    eor #$ff
    clc
    adc #1
    asl
    sta SCREEN+$a0,x
    inx
    cpx #$b
    bne b1
    rts
}
