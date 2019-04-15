// Tests that for()-loops can have empty inits
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    txa
    sta SCREEN,x
    inx
    cpx #$a
    bcc b1
    rts
}
