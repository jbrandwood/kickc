.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
  __b1:
    // b(i)
    jsr b
    // for(byte i:0..100)
    iny
    cpy #$65
    bne __b1
    // }
    rts
}
// b(byte register(Y) i)
b: {
    // c(i)
    tya
    jsr c
    // }
    rts
}
// c(byte register(A) i)
c: {
    ldx #0
  __b1:
    // SCREEN[j] = i
    sta SCREEN,x
    // for( byte j: 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
