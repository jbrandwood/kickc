// Demonstrates a problem where constant loophead unrolling results in an error
// The result is a NullPointerException
// The cause is that the Unroller does not handle the variable opcode correctly.
// The Unroller gets the verwions for opcode wrong because it misses the fact that it is modified inside call to popup_selector()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
// Offending unroll variable
main: {
    lda #'a'
    sta screen+$28
    jsr popup_selector
    sta screen+$29
    rts
}
popup_selector: {
    lda #'a'
    ldx #0
  b1:
    cpx #2+1
    bcc b2
    rts
  b2:
    lda #'b'
    sta screen,x
    inx
    jmp b1
}
