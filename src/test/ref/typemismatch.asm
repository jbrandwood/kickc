// Type mismatch - should fail gracefully
  // Commodore 64 PRG executable file
.file [name="typemismatch.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const w = $1388
    .const b = $ff&w
    .label screen = $400
    // screen[0] = b
    lda #b
    sta screen
    // }
    rts
}
