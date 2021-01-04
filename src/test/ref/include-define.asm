  // Commodore 64 PRG executable file
.file [name="include-define.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const x = 'a'
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = x
    lda #x
    sta SCREEN
    // }
    rts
}
