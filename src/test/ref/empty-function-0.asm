// Test removal of empty function
  // Commodore 64 PRG executable file
.file [name="empty-function-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const v = 7
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = v
    lda #v
    sta SCREEN
    // }
    rts
}
