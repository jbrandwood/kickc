// Test the preprocessor
// Test for existence of the __KICKC__ define
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // *SCREEN = 1
    lda #1
    sta SCREEN
    // }
    rts
}
