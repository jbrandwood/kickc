// Example of NOP-casting a dereferenced signed byte to a byte
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // SCREEN[i] = (byte) sbs[i]
    lda sbs,x
    sta SCREEN,x
    // for(byte i : 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
    sbs: .byte -1, -2, -3, -4
}
