// Test labels/goto
// a simple goto a forward label
  // Commodore 64 PRG executable file
.file [name="labelgoto-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[1] = '*'
    lda #'*'
    sta SCREEN+1
    // }
    rts
}
