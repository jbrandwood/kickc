.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  b1:
    cpx #$64
    bcc b2
    rts
  b2:
    inx
    jmp b1
}
