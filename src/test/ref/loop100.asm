.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b2:
    inx
    cpx #$64
    bcc b2
    rts
}
