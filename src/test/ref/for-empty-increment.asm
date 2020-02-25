// Tests that for()-loops can have empty increments
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // for(unsigned char i=0;i<10;)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i++
    txa
    sta SCREEN,x
    // SCREEN[i] = i++;
    inx
    jmp __b1
}
