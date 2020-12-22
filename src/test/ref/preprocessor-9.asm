// Test the preprocessor
// Macro with parameters
  // Commodore 64 PRG executable file
.file [name="preprocessor-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = SUM
    lda #'0'+4
    sta SCREEN
    // SCREEN[idx++] = DOUBLE
    lda #'b'+'b'
    sta SCREEN+1
    // SCREEN[idx++] = SQUARE
    lda #'c'*'c'
    sta SCREEN+2
    // }
    rts
}
