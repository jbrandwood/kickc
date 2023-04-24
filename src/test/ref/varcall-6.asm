// Test __varcall calling convention
// Struct parameter & return value
  // Commodore 64 PRG executable file
.file [name="varcall-6.prg", type="prg", segments="Program"]
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
    .const a_border = 1
    .const a_bg = 2
    // struct Cols c = plus(a, { 2, 3 })
    lda #a_border
    sta.z plus.a_border
    lda #a_bg
    sta.z plus.a_bg
    lda #2
    sta.z plus.b_border
    lda #3
    sta.z plus.b_bg
    jsr plus
    ldx.z plus.return_border
    lda.z plus.return_bg
    // *COLS = c
    stx COLS
    sta COLS+OFFSET_STRUCT_COLS_BG
    // plus(c, a)
    stx.z plus.a_border
    sta.z plus.a_bg
    lda #a_border
    sta.z plus.b_border
    lda #a_bg
    sta.z plus.b_bg
    jsr plus
    // c = plus(c, a)
    ldx.z plus.return_border
    lda.z plus.return_bg
    // *COLS = c
    stx COLS
    sta COLS+OFFSET_STRUCT_COLS_BG
    // }
    rts
}
// struct Cols plus(__zp(7) char a_border, __zp(6) char a_bg, __zp(3) char b_border, __zp(2) char b_bg)
plus: {
    .label a_border = 7
    .label a_bg = 6
    .label b_border = 3
    .label b_bg = 2
    .label return_border = 4
    .label return_bg = 5
    // a.border+b.border
    lda.z a_border
    clc
    adc.z b_border
    tax
    // a.bg+b.bg
    lda.z a_bg
    clc
    adc.z b_bg
    // return { a.border+b.border,  a.bg+b.bg };
    stx.z return_border
    sta.z return_bg
    // }
    rts
}
