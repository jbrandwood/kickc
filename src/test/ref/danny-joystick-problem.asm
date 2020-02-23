// Tests problem writing/reading joystick encountered by Danny Spijksma
// https://www.protovision.games/hardw/build4player.php?language=en&fbclid=IwAR1MJLgQjOU0zVa0ax2aNeGa-xVbE9IGY9zC6b6eInTV4HQzoUAoCPoXu14
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // CIA#2 Port B: RS-232
  .label CIA2_PORT_B = $dd01
  .label SCREEN = $400
main: {
    // (*CIA2_PORT_B) &= 0x7f
    lda #$7f
    and CIA2_PORT_B
    sta CIA2_PORT_B
    // asm
    lda #0
    // port4Value = *CIA2_PORT_B
    lda CIA2_PORT_B
    // *SCREEN = port4Value
    sta SCREEN
    // }
    rts
}
