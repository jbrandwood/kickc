// Minimal classic for() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // for(byte i=0; i!=100; i++)
    cpx #$64
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // for(byte i=0; i!=100; i++)
    inx
    jmp __b1
}
