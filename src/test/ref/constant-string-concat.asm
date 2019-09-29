// Concatenates string constants in different ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    lda s,x
    sta SCREEN,x
    inx
    cpx #8
    bne __b1
    rts
    s: .text "camelot"
    .byte 0
}
