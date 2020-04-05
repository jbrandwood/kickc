// Typedef const/volatile type
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const c = 'c'
  .label v = 2
__bbegin:
  // v = 'v'
  lda #'v'
  sta.z v
  jsr main
  rts
main: {
    // SCREEN[0] = c
    lda #c
    sta SCREEN
    // SCREEN[1] = v
    lda.z v
    sta SCREEN+1
    // }
    rts
}