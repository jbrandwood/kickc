// Support for pointer to struct member
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_SCREEN_COLORS_BG0 = 1
  .const SIZEOF_STRUCT_SCREEN_COLORS = 5
  // The border color
  .label BORDER_COLOR = COLORS
  // The background color
  .label BG_COLOR = COLORS+OFFSET_STRUCT_SCREEN_COLORS_BG0
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
  // Commodore 64 processor port
  COLORS: .fill SIZEOF_STRUCT_SCREEN_COLORS, 0
