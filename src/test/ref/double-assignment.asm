// Test that a double-assignment works.
  // Commodore 64 PRG executable file
.file [name="double-assignment.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const a = $c
    .label screen = $400
    // screen[0] = a
    lda #a
    sta screen
    // screen[1] = b
    sta screen+1
    // }
    rts
}
