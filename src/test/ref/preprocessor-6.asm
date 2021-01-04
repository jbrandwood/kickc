// Test the preprocessor
// Test macro recursion
  // Commodore 64 PRG executable file
.file [name="preprocessor-6.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const A = 'a'
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = A
    lda #A+1
    sta SCREEN
    // }
    rts
}
