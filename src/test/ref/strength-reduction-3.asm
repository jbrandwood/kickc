// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// Deref of a pointer cannot be hoisted
// *BGCOL+5 is NOT a loop invariant computation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label BGCOL = $d020
main: {
    ldx #0
  __b1:
    // for(char c=0;c<40;c++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // *BGCOL+5
    lda #5
    clc
    adc BGCOL
    // SCREEN[c] = *BGCOL+5
    sta SCREEN,x
    // for(char c=0;c<40;c++)
    inx
    jmp __b1
}
