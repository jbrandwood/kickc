  .const SCREEN = $400
  jsr main
main: {
    lda #1
    sta SCREEN
    rts
}
