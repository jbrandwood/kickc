// Local constant strings are placed at the start of the method. This means the generated ASM jumps / calls straignt into the constant string
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  b1:
    lda msg,x
    cmp #0
    bne b2
    rts
  b2:
    lda msg,x
    sta screen,x
    inx
    jmp b1
    msg: .text "message 2 "
    .byte 0
}
