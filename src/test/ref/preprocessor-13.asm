// Test the preprocessor
// No whitespace allowed between macro name and parenthesis when defining function-like macro
// http://www-tcad.stanford.edu/local/DOC/cpp_11.html
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
// Define FOO to take an argument and expand into double the argument
// Define BAR to take no argument and always expand into (x) + 2 * (x).
main: {
    .const x = 7
    .label SCREEN = $400
    // SCREEN[0] = FOO
    // Call without spaces
    lda #2*1
    sta SCREEN
    // SCREEN[1] = FOO
    // Call with spaces
    lda #2*2
    sta SCREEN+1
    // SCREEN[2] = BAR
    // Call macro without parameters
    lda #x+2*x
    sta SCREEN+2
    // }
    rts
}
