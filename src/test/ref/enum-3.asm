// Test of simple enum - value with complex calculation
  // Commodore 64 PRG executable file
.file [name="enum-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const BROKEN = 4*4+2+1
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = state
    lda #BROKEN
    sta SCREEN
    // }
    rts
}
