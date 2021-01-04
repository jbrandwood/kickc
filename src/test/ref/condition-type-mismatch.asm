// Tests a condition type mismatch (not boolean)
  // Commodore 64 PRG executable file
.file [name="condition-type-mismatch.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // *screen = 'a'
    lda #'a'
    sta screen
    // }
    rts
}
