// Support for pointer to struct member
  // Commodore 64 PRG executable file
.file [name="struct-pointer-to-member.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_SCREEN_COLORS_BG0 = 1
  // Commodore 64 processor port
  .label COLORS = $d020
  // The background color
  .label BG_COLOR = COLORS+OFFSET_STRUCT_SCREEN_COLORS_BG0
.segment Code
main: {
    // COLORS->BORDER = 0
    lda #0
    sta COLORS
    // *BG_COLOR = 6
    lda #6
    sta BG_COLOR
    // }
    rts
}
