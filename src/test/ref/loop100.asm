.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b1:
    inx
    cpx #$64
    bcc b1
    rts
}
