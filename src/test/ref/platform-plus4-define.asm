// Test the #define for the plus4 target platform
.pc = $1001 "Basic"
:BasicUpstart(main)
.pc = $100d "Program"

  .label SCREEN = $c00
main: {
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
