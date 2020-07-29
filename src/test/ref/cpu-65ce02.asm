// Test the 65CE02 CPU
// A program that uses 65CE02 instructions
.cpu _65ce02
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // a = SCREEN[0]
    lda SCREEN
    // a = -a
    neg
    // SCREEN[1] = a
    sta SCREEN+1
    // a/4
    asr
    asr
    // SCREEN[2] = a/4
    // Becomes a NEG
    sta SCREEN+2
    // }
    rts
}
