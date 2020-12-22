// Tests the ternary operator - when the condition is constant
  // Commodore 64 PRG executable file
.file [name="ternary-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = true?'a':'b'
    lda #'a'
    sta SCREEN
    // SCREEN[1] = false?'a':'b'
    lda #'b'
    sta SCREEN+1
    // }
    rts
}
