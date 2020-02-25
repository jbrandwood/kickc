// Tests creating and assigning pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if((i&1)==0)
    cmp #0
    // for ( byte i: 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
