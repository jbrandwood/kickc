  // Commodore 64 PRG executable file
.file [name="bgblack.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const BLACK = 0
  .label BG_COLOR = $d021
.segment Code
main: {
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // }
    rts
}
