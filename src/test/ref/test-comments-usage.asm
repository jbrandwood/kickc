// Tests that single-line comments are only included once in the output
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
// The program entry point
main: {
    // *SCREEN = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
