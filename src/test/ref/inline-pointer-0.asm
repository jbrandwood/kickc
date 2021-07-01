// Tests creating a literal pointer from two bytes
  // Commodore 64 PRG executable file
.file [name="inline-pointer-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = 4*$100+0
    // *screen = 'a'
    lda #'a'
    sta screen
    // }
    rts
}
