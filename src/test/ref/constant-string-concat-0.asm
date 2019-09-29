// Concatenates string constants in different ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    lda msg,x
    cmp #0
    bne __b2
    rts
  __b2:
    lda msg,x
    sta SCREEN,x
    inx
    jmp __b1
    msg: .text "camelot"
    .byte 0
}
