// Test that bitwise NOT (~) is handled correctly
  // Commodore 64 PRG executable file
.file [name="bitwise-not-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = $10^$ff
    .label screen = $400
    // *screen = b
    lda #b
    sta screen
    // }
    rts
}
