// Test of simple enum - struct with inline anonymous enum
  // Commodore 64 PRG executable file
.file [name="enum-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const RED = 2
.segment Code
main: {
    .const button_size = $18
    .label SCREEN = $400
    // SCREEN[0] = button.color
    lda #RED
    sta SCREEN
    // SCREEN[1] = button.size
    lda #button_size
    sta SCREEN+1
    // }
    rts
}
