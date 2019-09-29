// Test a problem with converting casted constant numbers to fixed type constant integers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #$79
  __b1:
    txa
    lsr
    lsr
    lsr
    lsr
    sta SCREEN,x
    inx
    cpx #$7b
    bne __b1
    rts
}
