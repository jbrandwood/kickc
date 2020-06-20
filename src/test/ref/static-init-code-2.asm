// Tests static initialization code
// No initializer code should be needed (since all values are constant)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const c1 = 'o'
  .const c2 = 'k'
  .label SCREEN = $400
main: {
    // SCREEN[0] = c1
    lda #c1
    sta SCREEN
    // SCREEN[1] = c2
    lda #c2
    sta SCREEN+1
    // }
    rts
}
