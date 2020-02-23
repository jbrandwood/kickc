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
    // screen[40] = opcode
    lda #'a'
    sta screen+$28
    // popup_selector()
    jsr popup_selector
    // screen[41] = opcode
    sta screen+$29
    // }
    rts
}
popup_selector: {
    lda #'a'
    ldx #0
  __b1:
    // for (byte k = 0; k <= 2; k++)
    cpx #2+1
    bcc __b2
    // }
    rts
  __b2:
    // screen[k] = opcode
    lda #'b'
    sta screen,x
    // for (byte k = 0; k <= 2; k++)
    inx
    jmp __b1
}
