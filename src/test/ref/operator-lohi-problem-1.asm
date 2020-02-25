// Illustrates problem with constant evaluation of lo/hi-operator
// $20000 /$400 results in a byte value - confusing the lo/hi-evaluation
// which currently relies on getting the type from the literal value.
// A fix could be adding support for "declared" types for constant literal values
// - enabling the lo/hi to know that their operand is a word (from the cast).
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const DVAL = $20000
  .label SCREEN = $400
main: {
    // SCREEN[0] = <(word)(DVAL/$400)
    lda #<DVAL/$400
    sta SCREEN
    // SCREEN[1] = >(word)(DVAL/$400)
    lda #0
    sta SCREEN+1
    // }
    rts
}
