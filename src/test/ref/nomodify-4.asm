// Test that a nomodify parameter works
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #'a'
    sta.z print.c
    jsr print
    lda #'b'
    sta.z print.c
    jsr print
    rts
}
print: {
    .label c = 2
    lda.z c
    sta SCREEN
    rts
}
