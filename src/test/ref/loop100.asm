.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  __b1:
    // for(byte i=0; i<100; i++)
    cpx #$64
    bcc __b2
    // }
    rts
  __b2:
    // for(byte i=0; i<100; i++)
    inx
    jmp __b1
}
