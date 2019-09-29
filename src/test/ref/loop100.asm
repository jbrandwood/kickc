.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  __b1:
    cpx #$64
    bcc __b2
    rts
  __b2:
    inx
    jmp __b1
}
