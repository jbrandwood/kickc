// Test that a volatile nomodify-variable works as expected
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label i = 2
__bbegin:
  // i = 7
  lda #7
  sta.z i
  jsr main
  rts
main: {
    // SCREEN[0] = i
    lda.z i
    sta SCREEN
    // }
    rts
}
