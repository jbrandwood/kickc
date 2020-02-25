// Illustrates problem with constant evaluation of lo/hi-operator
// $20000 /$400 results in a byte value - confusing the lo/hi-evaluation
// which currently relies on getting the type from the literal value.
// A fix could be adding support for "declared" types for constant literal values
// - enabling the lo/hi to know that their operand is a word (from the cast).
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const dw = $2000
    .const w1 = dw&$ffff
    .const w2 = dw+1&$ffff
    // SCREEN[0] = <w1
    lda #0
    sta SCREEN
    // SCREEN[1] = >w1
    lda #>w1
    sta SCREEN+1
    // SCREEN[3] = <w2
    lda #<w2
    sta SCREEN+3
    // SCREEN[4] = >w2
    lda #>w2
    sta SCREEN+4
    // }
    rts
}
