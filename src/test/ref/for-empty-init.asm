// Tests that for()-loops can have empty inits
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // for(;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // for(;i<10;i++)
    inx
    jmp __b1
}
