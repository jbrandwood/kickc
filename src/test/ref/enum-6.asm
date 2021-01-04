// Test of simple enum - anonymous enum definition
  // Commodore 64 PRG executable file
.file [name="enum-6.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const OFF = 0
    .const ON = 1
    .label SCREEN = $400
    // SCREEN[0] = state
    lda #ON
    sta SCREEN
    // SCREEN[1] = state
    lda #OFF
    sta SCREEN+1
    // }
    rts
}
