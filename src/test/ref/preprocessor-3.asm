// Test the preprocessor
// #define inside an #included file
  // Commodore 64 PRG executable file
.file [name="preprocessor-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Test the preprocessor
  // #define inside an #included file
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = STAR
    lda #'*'
    sta SCREEN
    // }
    rts
}
