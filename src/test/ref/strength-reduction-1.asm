// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// x+5 is a loop invariant computation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // x = *SCREEN
    lda SCREEN
    // x+5
    clc
    adc #5
    ldx #0
  __b1:
    // for(char c=0;c<40;c++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[c] = x+5
    sta SCREEN,x
    // for(char c=0;c<40;c++)
    inx
    jmp __b1
}
