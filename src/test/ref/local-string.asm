// Local constant strings are placed at the start of the method. This means the generated ASM jumps / calls straignt into the constant string
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldy #0
  b1:
    lda #0
    cmp msg,y
    bne b2
    rts
  b2:
    lda msg,y
    sta screen,y
    iny
    jmp b1
    msg: .text "message 2 "
    .byte 0
}
