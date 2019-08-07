// Tests that for()-loops can have empty increments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b2:
    txa
    sta SCREEN,x
    inx
    cpx #$a
    bcc b2
    rts
}
