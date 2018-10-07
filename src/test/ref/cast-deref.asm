.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    lda sbs,x
    sta SCREEN,x
    inx
    cpx #4
    bne b1
    rts
    sbs: .byte -1, -2, -3, -4
}
