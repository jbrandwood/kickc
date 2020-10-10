// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// Only expressions on all execution paths in the loop can be hoisted out
// (y = 0;) is not on every loop execution path and should not be hoisted
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // y = SCREEN[0]
    lda SCREEN
    ldx #0
  __b1:
    // for(char c=0;c<40;c++)
    cpx #$28
    bcc __b2
    // SCREEN[80] = y
    sta SCREEN+$50
    // }
    rts
  __b2:
    // if(c==10)
    cpx #$a
    bne __b4
    lda #0
  __b4:
    // for(char c=0;c<40;c++)
    inx
    jmp __b1
}
