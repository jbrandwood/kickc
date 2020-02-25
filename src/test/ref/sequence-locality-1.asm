// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
    ldy #0
  __b1:
    // if(i>5)
    cpy #5+1
    bcc __b4
    // j += i
    tya
    asl
  __b2:
    // screen[idx++] = j
    sta screen,x
    // screen[idx++] = j;
    inx
    // for(byte i: 0..10)
    iny
    cpy #$b
    bne __b1
    // }
    rts
  __b4:
    tya
    jmp __b2
}
