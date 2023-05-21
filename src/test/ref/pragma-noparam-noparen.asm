// Test that #pragma works with no parenthesis and no parameters
  // Commodore 64 PRG executable file
.file [name="pragma-noparam-noparen.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
