// Test that struct variable and members can both have type directives
  // Commodore 64 PRG executable file
.file [name="struct-directives.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = y.x
    lda y
    sta SCREEN
    // SCREEN[0] = y.z
    lda y+1
    sta SCREEN
    // }
    rts
}
.segment Data
  y: .byte 1, 2
