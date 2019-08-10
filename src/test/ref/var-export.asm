// Test the export directive usable for ensuring a data variable is always added to the output - even if it is never used
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #'x'
    sta SCREEN
    rts
}
  MESSAGE: .text "camelot!"
  .byte 0
