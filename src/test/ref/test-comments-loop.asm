.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  // Do some sums
  b1:
    lda #'a'
    sta SCREEN,x
    inx
    cpx #$b
    bne b1
    rts
}
