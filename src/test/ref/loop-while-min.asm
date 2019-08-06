// Minimal classic while() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b2:
    txa
    sta SCREEN,x
    inx
    cpx #$64
    bne b2
    rts
}
