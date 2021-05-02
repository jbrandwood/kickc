// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
  // Commodore 64 PRG executable file
.file [name="strength-reduction-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // char x = *SCREEN
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
