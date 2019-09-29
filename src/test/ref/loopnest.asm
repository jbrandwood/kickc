.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #$64
  __b1:
    jsr nest
    dey
    cpy #0
    bne __b1
    rts
}
nest: {
    ldx #$64
  __b1:
    stx SCREEN
    dex
    cpx #0
    bne __b1
    rts
}
