// Tests simple switch()-statement - switch without default
// Expected output " 1  4 "
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    cpx #1
    beq b2
    cpx #4
    bne b3
  b2:
    txa
    clc
    adc #'0'
    sta SCREEN,x
  b3:
    inx
    cpx #6
    bne b1
    rts
}
