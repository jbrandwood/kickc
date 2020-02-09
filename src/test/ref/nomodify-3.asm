// Test that a volatile nomodify-variable works as expected
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label i = 2
__bbegin:
  lda #7
  sta.z i
  jsr main
  rts
main: {
    lda.z i
    sta SCREEN
    rts
}
