// Local constant strings are placed at the start of the method. This means the generated ASM jumps / calls straignt into the constant string
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    // while(msg[i])
    lda msg,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // screen[i++] = msg[i]
    lda msg,x
    sta screen,x
    // screen[i++] = msg[i];
    inx
    jmp __b1
    msg: .text "message 2 "
    .byte 0
}
