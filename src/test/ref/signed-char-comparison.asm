// Illustrates problem with > comparison of signed chars.
// Reported by Danny Spijksma
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #-$80
  __b1:
    jsr debug
    inx
    cpx #-$80
    bne __b1
    rts
}
// debug(signed byte register(X) dy)
debug: {
    txa
    sec
    sbc #-$78
    beq __breturn
    bvc !+
    eor #$80
  !:
    bmi __breturn
    lda #$a
    sta SCREEN,x
  __breturn:
    rts
}
