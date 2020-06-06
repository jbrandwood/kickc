// Test parenthesising of constants
// See https://gitlab.com/camelot/kickc/-/issues/470#note_356486132
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const dy = $80
    // SCREEN[0] = (dy-1)/16
    // A parenthesis should be added in the ASM to ensure operator precedence 
    lda #(dy-1)/$10
    sta SCREEN
    // SCREEN[1] = (dy-1)>>4
    // No parenthesis should be added in the ASM because minus (-) has higher precedence than shift (>>)
    lda #dy-1>>4
    sta SCREEN+1
    // }
    rts
}
