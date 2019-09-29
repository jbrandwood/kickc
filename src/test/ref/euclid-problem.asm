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
  __b1:
    cpx.z a
    bne __b2
    lda.z a
    sta SCREEN
    rts
  __b2:
    cpx.z a
    bcc __b4
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b4:
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp __b1
}
