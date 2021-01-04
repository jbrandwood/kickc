// Test of simple enum - two-value enum
  // Commodore 64 PRG executable file
.file [name="enum-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const ON = 1
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = state
    lda #ON
    sta SCREEN
    // }
    rts
}
