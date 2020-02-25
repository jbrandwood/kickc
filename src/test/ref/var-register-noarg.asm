// Test declaring a variable as register with no information about which register (for compatibility with standard C)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // while(i<40*4)
    cpx #$28*4
    bcc __b2
    // }
    rts
  __b2:
    // i&7
    txa
    and #7
    // SCREEN[i++] = MSG[i&7]
    tay
    lda MSG,y
    sta SCREEN,x
    // SCREEN[i++] = MSG[i&7];
    inx
    jmp __b1
}
.encoding "screencode_upper"
  MSG: .text "CAMELOT!"
  .byte 0
