// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldy #0
    ldx #0
  __b1:
    // if(i>5)
    cpx #5+1
    bcs __b2
    // i-5
    txa
    sec
    sbc #5
    // screen[idx++] = i-5
    sta screen,y
    // screen[idx++] = i-5;
    iny
  __b3:
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
  __b2:
    // screen[idx++] = i
    txa
    sta screen,y
    // screen[idx++] = i;
    iny
    jmp __b3
}
