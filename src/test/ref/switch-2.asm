// Tests simple switch()-statement - not inside a loop
  // Commodore 64 PRG executable file
.file [name="switch-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = 1
    .label SCREEN = $400
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // }
    rts
}
