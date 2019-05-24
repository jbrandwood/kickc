// Concatenates string constants in different ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    lda msg,x
    sta SCREEN,x
    inx
    lda msg,x
    cmp #0
    bne b1
    rts
    msg: .text "camelot@"
}
