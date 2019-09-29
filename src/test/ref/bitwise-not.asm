.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #1^$ff
    sta SCREEN
    ldx #1
  __b1:
    txa
    eor #$ff
    sta SCREEN,x
    inx
    cpx #$1b
    bne __b1
    rts
}
