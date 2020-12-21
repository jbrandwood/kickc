// Support for pointer to struct member
  // Commodore 64 PRG executable file
.file [name="struct-pointer-to-member-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_SCREEN_COLORS_BG0 = 1
  .const SIZEOF_STRUCT_SCREEN_COLORS = 5
  // The border color
  .label BORDER_COLOR = COLORS
  // The background color
  .label BG_COLOR = COLORS+OFFSET_STRUCT_SCREEN_COLORS_BG0
.segment Code
main: {
    // *BORDER_COLOR = 0
    lda #0
    sta BORDER_COLOR
    // *BG_COLOR = 6
    lda #6
    sta BG_COLOR
    // }
    rts
}
.segment Data
  // Commodore 64 processor port
  COLORS: .fill SIZEOF_STRUCT_SCREEN_COLORS, 0
