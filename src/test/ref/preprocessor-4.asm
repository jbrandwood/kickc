// Test the preprocessor
// Test #ifdef
  // Commodore 64 PRG executable file
.file [name="preprocessor-4.prg", type="prg", segments="Program"]
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
    // SCREEN[idx++] = 'a'
    lda #'a'
    sta SCREEN+1
    // SCREEN[idx++] = '-'
    lda #'-'
    sta SCREEN+2
    // }
    rts
}
