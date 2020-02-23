.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #$64
  __b1:
    // nest()
    jsr nest
    // while (--i>0)
    dey
    cpy #0
    bne __b1
    // }
    rts
}
nest: {
    ldx #$64
  __b1:
    // *SCREEN = j
    stx SCREEN
    // while (--j>0)
    dex
    cpx #0
    bne __b1
    // }
    rts
}
