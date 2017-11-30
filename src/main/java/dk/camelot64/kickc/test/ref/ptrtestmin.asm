.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    ldx #2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    inx
    jmp b1
}
