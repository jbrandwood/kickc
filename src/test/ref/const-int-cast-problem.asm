// Test a problem with converting casted constant numbers to fixed type constant integers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #$79
  __b1:
    // i>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // SCREEN[i] = i>>4
    sta SCREEN,x
    // for( byte i: 121..122)
    inx
    cpx #$7b
    bne __b1
    // }
    rts
}
