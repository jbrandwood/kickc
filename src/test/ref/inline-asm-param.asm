.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #'a'
  __b1:
    lda #'a'
    sta SCREEN
    inx
    iny
    cpy #4
    bne __b1
    rts
}
