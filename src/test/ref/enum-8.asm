// Test of simple enum - struct with inline anonymous enum
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const RED = 2
main: {
    .label SCREEN = $400
    .const button_size = $18
    // SCREEN[0] = button.color
    lda #RED
    sta SCREEN
    // SCREEN[1] = button.size
    lda #button_size
    sta SCREEN+1
    // }
    rts
}
