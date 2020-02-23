.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldy #0
    ldx #-$7f
  __b1:
    // while(i<127)
    txa
    sec
    sbc #$7f
    bvc !+
    eor #$80
  !:
    bmi __b2
    // }
    rts
  __b2:
    // screen[j] = (byte)i
    txa
    sta screen,y
    // i++;
    inx
    // j++;
    iny
    jmp __b1
}
