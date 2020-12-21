// Test the preprocessor
// No whitespace allowed between macro name and parenthesis when defining function-like macro
// http://www-tcad.stanford.edu/local/DOC/cpp_11.html
  // Commodore 64 PRG executable file
.file [name="preprocessor-13.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
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
