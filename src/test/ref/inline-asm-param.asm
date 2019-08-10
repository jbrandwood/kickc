.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    lda #'a'
    sta SCREEN
    inx
    cpx #4
    bne b1
    rts
}
