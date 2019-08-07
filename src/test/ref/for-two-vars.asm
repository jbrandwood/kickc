// Test a for-loop with two iterating variables
// Illustrates that for()-loops currently cannot contain two variable declarations.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label sc = 2
    lda #<SCREEN+$27
    sta.z sc
    lda #>SCREEN+$27
    sta.z sc+1
    ldx #0
  b2:
    txa
    ldy #0
    sta (sc),y
    inx
    lda.z sc
    bne !+
    dec.z sc+1
  !:
    dec.z sc
    cpx #$28
    bcc b2
    rts
}
