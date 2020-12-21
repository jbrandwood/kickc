// Test of simple enum - multiple inline enum definitions
  // Commodore 64 PRG executable file
.file [name="enum-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const ON = 1
    .label SCREEN = $400
    // *SCREEN = state
    lda #ON
    sta SCREEN
    // test()
    jsr test
    // }
    rts
}
test: {
    .const ON = 8
    .label SCREEN = $428
    // *SCREEN = state
    lda #ON
    sta SCREEN
    // }
    rts
}
