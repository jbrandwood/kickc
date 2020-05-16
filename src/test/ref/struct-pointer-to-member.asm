// Support for pointer to struct member
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_SCREEN_COLORS_BG0 = 1
  // Commodore 64 processor port
  .label COLORS = $d020
  // The background color
  .label BG_COLOR = COLORS+OFFSET_STRUCT_SCREEN_COLORS_BG0
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