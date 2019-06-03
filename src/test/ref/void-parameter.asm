// Test that void-parameter works top specify function takes no parameters
// Out
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    jsr print
    jsr print
    jsr print
    rts
}
print: {
    lda #'.'
    sta SCREEN,x
    inx
    rts
}
