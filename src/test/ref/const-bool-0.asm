// Tests a complex constant binary
  // Commodore 64 PRG executable file
.file [name="const-bool-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // *screen = bError
    lda #7&(($10|$20|$40)^$ff)
    sta screen
    // }
    rts
}
