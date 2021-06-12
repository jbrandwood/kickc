// Tests ASM constant operator precedence
  // Commodore 64 PRG executable file
.file [name="precedence-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = 1+2*3*4+5*6|7
    lda #1+2*3*4+5*6|7
    sta SCREEN
    // }
    rts
}
