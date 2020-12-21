// Tests subtracting a number from a literal char
  // Commodore 64 PRG executable file
.file [name="literal-char-minus-number.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = 'a' - 1
    lda #0
    sta SCREEN
    // }
    rts
}
