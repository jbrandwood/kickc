// Tests uninitialized values of variables.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const b = 0
  .label SCREEN = $400
main: {
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // SCREEN[2] = <w
    lda #0
    sta SCREEN+2
    // SCREEN[3] = >w
    sta SCREEN+3
    // SCREEN[5] = (byte)<ptr
    sta SCREEN+5
    // SCREEN[5] = (byte)>ptr
    sta SCREEN+5
    // }
    rts
}
