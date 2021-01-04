// Use an uninitialized variable - should use the default value (0)!
  // Commodore 64 PRG executable file
.file [name="useuninitialized.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const b = 3
  .const s = 1
.segment Code
main: {
    .label screen = $400
    // *screen = b
    lda #b
    sta screen
    // *(screen+1) = s
    lda #s
    sta screen+1
    // }
    rts
}
