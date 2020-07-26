// Test the 65C02 CPU
// A program that uses 65C02 instructions
.cpu _65c02
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // a = SCREEN[0]
    lda SCREEN
    // a+1
    inc
    // SCREEN[1] = a+1
    sta SCREEN+1
    // }
    rts
}
