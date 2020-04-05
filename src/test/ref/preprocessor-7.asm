// Test the preprocessor
// Macro generating inline ASM
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SEI
    sei
    // SCREEN[idx++] = 'x'
    lda #'x'
    sta SCREEN
    // CLI
    cli
    // }
    rts
}
