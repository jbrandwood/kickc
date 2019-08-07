// Concatenates string constants in different ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    lda msg,x
    cmp #0
    bne b2
    rts
  b2:
    lda msg,x
    sta SCREEN,x
    inx
    jmp b1
    msg: .text "camelot"
    .byte 0
}
