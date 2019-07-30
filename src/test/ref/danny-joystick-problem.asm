// Tests problem writing/reading joystick encountered by Danny Spijksma
// https://www.protovision.games/hardw/build4player.php?language=en&fbclid=IwAR1MJLgQjOU0zVa0ax2aNeGa-xVbE9IGY9zC6b6eInTV4HQzoUAoCPoXu14
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // CIA#2 Port B: RS-232
  .label CIA2_PORT_B = $dd01
  .label SCREEN = $400
main: {
    lda #$7f
    and CIA2_PORT_B
    sta CIA2_PORT_B
    lda #0
    lda CIA2_PORT_B
    sta SCREEN
    rts
}
