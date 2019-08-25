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
    sta.z a
  b1:
    cpx.z a
    bne b2
    lda.z a
    sta SCREEN
    rts
  b2:
    cpx.z a
    bcc b4
    txa
    sec
    sbc.z a
    tax
    jmp b1
  b4:
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp b1
}
