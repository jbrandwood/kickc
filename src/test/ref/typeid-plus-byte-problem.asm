// Test that byte+byte creates a byte - even when there is a value overflow
  // Commodore 64 PRG executable file
.file [name="typeid-plus-byte-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const ubc1 = $c+$d+$e
    .const ubc2 = $fa
    // SCREEN[0] = ubc1+ubc2
    lda #ubc1+ubc2
    sta SCREEN
    // }
    rts
}
