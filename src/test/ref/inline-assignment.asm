.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // SCREEN[i] = a = i
    txa
    sta SCREEN,x
    // (SCREEN+80)[i] = a
    txa
    sta SCREEN+$50,x
    // for( byte i : 0..39)
    inx
    cpx #$28
    bne __b1
    // }
    rts
}
