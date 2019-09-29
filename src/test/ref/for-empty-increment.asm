// Tests that for()-loops can have empty increments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    cpx #$a
    bcc __b2
    rts
  __b2:
    txa
    sta SCREEN,x
    inx
    jmp __b1
}
