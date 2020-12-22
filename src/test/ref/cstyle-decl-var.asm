// Test declarations of variables without definition
  // Commodore 64 PRG executable file
.file [name="cstyle-decl-var.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // The actual declarations
  .label SCREEN = $400
.segment Code
// And a little code using them
main: {
    // SCREEN[idx++] = 'c'
    lda #'c'
    sta SCREEN
    // SCREEN[idx++] = 'm'
    lda #'m'
    sta SCREEN+1
    // SCREEN[idx++] = 'l'
    lda #'l'
    sta SCREEN+2
    // }
    rts
}
