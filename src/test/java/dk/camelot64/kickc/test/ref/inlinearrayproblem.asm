.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const SCREEN2 = $400+$28
  jsr main
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
