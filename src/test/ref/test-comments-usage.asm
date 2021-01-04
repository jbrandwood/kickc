// Tests that single-line comments are only included once in the output
  // Commodore 64 PRG executable file
.file [name="test-comments-usage.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
// The program entry point
main: {
    // *SCREEN = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
