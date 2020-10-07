// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// Complex expressions can also be loop invariant computations
// (x+5)*2 is a loop invariant computations
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // x = SCREEN[0]
    lda SCREEN
    // x+5
    clc
    adc #5
    // (x+5)*2
    asl
    ldx #0
  __b1:
    // for(char c=0;c<40;c++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[c] = (x+5)*2
    sta SCREEN,x
    // for(char c=0;c<40;c++)
    inx
    jmp __b1
}
