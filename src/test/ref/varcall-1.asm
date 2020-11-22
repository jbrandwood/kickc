// Test __varcall calling convention
// Parameter passing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
// setbg(byte zp(2) col)
setbg: {
    .label col = 2
    // *BGCOL = col
    lda.z col
    sta BGCOL
    // }
    rts
}
main: {
    // setbg(0)
    lda #0
    sta.z setbg.col
    jsr setbg
    // setbg(0x0b)
    lda #$b
    sta.z setbg.col
    jsr setbg
    // }
    rts
}
