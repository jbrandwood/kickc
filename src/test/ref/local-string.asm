.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Local constant strings are placed at the start of the method. This means the generated ASM jumps / calls straignt into the constant string
main: {
    .label screen = $400
    ldx #0
  b1:
    lda msg,x
    cmp #'@'
    bne b2
    rts
  b2:
    lda msg,x
    sta screen,x
    inx
    jmp b1
    msg: .text "message 2 @"
}
