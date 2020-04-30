// Support for pointer to struct member
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_SCREEN_COLORS_BG0 = 1
  .const SIZEOF_STRUCT_SCREEN_COLORS = 5
  // The border color
  .label BORDERCOL = COLORS
  // The background color
  .label BGCOL = COLORS+OFFSET_STRUCT_SCREEN_COLORS_BG0
main: {
    // *BORDERCOL = 0
    lda #0
    sta BORDERCOL
    // *BGCOL = 6
    lda #6
    sta BGCOL
    // }
    rts
}
  // Commodore 64 processor port
  COLORS: .fill SIZEOF_STRUCT_SCREEN_COLORS, 0
