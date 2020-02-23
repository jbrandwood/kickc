// Minimal classic while() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // while(i!=100)
    cpx #$64
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // i++;
    inx
    jmp __b1
}
