// Test a for-loop with two iterating variables
// Illustrates that for()-loops currently cannot contain two variable declarations.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label sc = 2
    lda #<SCREEN+$27
    sta sc
    lda #>SCREEN+$27
    sta sc+1
    ldx #0
  b1:
    txa
    ldy #0
    sta (sc),y
    inx
    lda sc
    bne !+
    dec sc+1
  !:
    dec sc
    cpx #$28
    bcc b1
    rts
}
