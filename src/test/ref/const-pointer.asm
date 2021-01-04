//Test that constant pointers are detected correctly
  // Commodore 64 PRG executable file
.file [name="const-pointer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // screen[0] = '*'
    lda #'*'
    sta screen
    // }
    rts
}
