// Test __varcall calling convention
// Struct parameter & return value - only a single call
  // Commodore 64 PRG executable file
.file [name="varcall-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_COLS_BG = 1
  .label COLS = $d020
.segment Code
main: {
    .label a_border = 1
    .label a_bg = 2
    .label b_border = 2
    .label b_bg = 3
    // struct Cols c = plus(a, b)
    jsr plus
    // *COLS = c
    lda #plus.return_border
    sta COLS
    lda #plus.return_bg
    sta COLS+OFFSET_STRUCT_COLS_BG
    // }
    rts
}
plus: {
    .label return_border = main.a_border+main.b_border
    .label return_bg = main.a_bg+main.b_bg
    rts
}
