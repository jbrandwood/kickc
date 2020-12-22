// Test the preprocessor
// Test multi-line macro
  // Commodore 64 PRG executable file
.file [name="preprocessor-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN
    // PRINTXX
    lda #'x'
    sta SCREEN+1
    sta SCREEN+2
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN+3
    // }
    rts
}
