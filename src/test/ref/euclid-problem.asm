// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label a = 2
    ldx #2
    lda #$80
    sta a
  b1:
    cpx a
    bne b2
    lda a
    sta SCREEN
    rts
  b2:
    cpx a
    bcc b4
    txa
    sec
    sbc a
    tax
    jmp b1
  b4:
    txa
    eor #$ff
    sec
    adc a
    sta a
    jmp b1
}
