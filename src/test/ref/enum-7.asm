// Test of simple enum - struct with enum
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const RED = 0
main: {
    .const button_size = $18
    .label SCREEN = $400
    // SCREEN[0] = button.color
    lda #RED
    sta SCREEN
    // SCREEN[1] = button.size
    lda #button_size
    sta SCREEN+1
    // }
    rts
}
