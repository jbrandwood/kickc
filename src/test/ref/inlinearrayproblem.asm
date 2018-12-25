.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
main: {
    ldx #0
  b1:
    lda txt,x
    sta SCREEN,x
    lda data,x
    sta SCREEN2,x
    inx
    cpx #4
    bne b1
    rts
    txt: .text "qwe"
    data: .byte 1, 2, 3
}
