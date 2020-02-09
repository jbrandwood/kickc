// Test of simple enum - struct with inline anonymous enum
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const RED = 2
main: {
    .label SCREEN = $400
    .const button_size = $18
    lda #RED
    sta SCREEN
    lda #button_size
    sta SCREEN+1
    rts
}
