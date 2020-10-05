// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // x = *SCREEN
    ldx SCREEN
    ldy #0
  __b1:
    // for(char c=0;c<40;c++)
    cpy #$28
    bcc __b2
    // }
    rts
  __b2:
    // x+5
    txa
    clc
    adc #5
    // SCREEN[c] = x+5
    // x+5 is a loop invariant computation
    sta SCREEN,y
    // for(char c=0;c<40;c++)
    iny
    jmp __b1
}
