// Test effective live range and register allocation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    ldy #0
  __b1:
    // out(msg[i])
    lda msg,y
    jsr out
    // for( byte i: 0..11)
    iny
    cpy #$c
    bne __b1
    // }
    rts
}
// out(byte register(A) c)
out: {
    // SCREEN[idx++] = c
    sta SCREEN,x
    // SCREEN[idx++] = c;
    inx
    // }
    rts
}
  msg: .text "hello world!"
  .byte 0
