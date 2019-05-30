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
    .const w2 = dw+1&$ffff
    lda #0
    sta SCREEN
    sta SCREEN+1
    lda #<w2
    sta SCREEN+3
    lda #>w2
    sta SCREEN+4
    rts
}
