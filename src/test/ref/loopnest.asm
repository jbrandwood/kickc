.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #$64
  b1:
    jsr nest
    dey
    cpy #0
    bne b1
    rts
}
nest: {
    ldx #$64
  b1:
    stx SCREEN
    dex
    cpx #0
    bne b1
    rts
}
