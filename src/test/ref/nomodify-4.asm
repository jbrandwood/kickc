// Test that a nomodify parameter works
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #'a'
    jsr print
    lda #'b'
    jsr print
    rts
}
// print(byte register(A) c)
print: {
    sta SCREEN
    rts
}
