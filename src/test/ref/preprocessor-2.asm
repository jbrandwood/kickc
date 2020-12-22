// Test the preprocessor
// #define and #undef - expected output on screen is xa
  // Commodore 64 PRG executable file
.file [name="preprocessor-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const a = 'a'
    // SCREEN[0] = a
    lda #'x'
    sta SCREEN
    // SCREEN[1] = a
    lda #a
    sta SCREEN+1
    // }
    rts
}
