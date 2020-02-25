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
    // while (a!=b)
    cpx.z a
    bne __b2
    // *SCREEN = a
    lda.z a
    sta SCREEN
    // }
    rts
  __b2:
    // if(a>b)
    cpx.z a
    bcc __b4
    // b = b-a
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b4:
    // a = a-b
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp __b1
}
