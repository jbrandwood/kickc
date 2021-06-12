// Illustrates problem with constant evaluation of lo/hi-operator
// $20000 /$400 results in a byte value - confusing the lo/hi-evaluation
// which currently relies on getting the type from the literal value.
// A fix could be adding support for "declared" types for constant literal values
// - enabling the lo/hi to know that their operand is a word (from the cast).
  // Commodore 64 PRG executable file
.file [name="operator-lohi-problem-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const DVAL = $20000
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = BYTE0((word)(DVAL/$400))
    lda #<DVAL/$400
    sta SCREEN
    // SCREEN[1] = BYTE1((word)(DVAL/$400))
    lda #0
    sta SCREEN+1
    // }
    rts
}
