// Test that void-parameter works top specify function takes no parameters
// Output is "..." in the top left corner of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // print()
    ldx #0
    jsr print
    // print()
    jsr print
    // print()
    jsr print
    // }
    rts
}
print: {
    // SCREEN[idx++] = '.'
    lda #'.'
    sta SCREEN,x
    // SCREEN[idx++] = '.';
    inx
    // }
    rts
}
