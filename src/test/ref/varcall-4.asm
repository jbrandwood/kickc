// Test __varcall calling convention
// Struct parameter
  // Commodore 64 PRG executable file
.file [name="varcall-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_COLS_BG = 1
  .const OFFSET_STRUCT_COLS_FG = 2
  .const SIZEOF_STRUCT_COLS = 3
  .label COLS = $d020
.segment Code
// __zp(7) char fg_sum(__zp(2) char a_border, __zp(3) char a_bg, __zp(8) char a_fg, __zp(4) char b_border, __zp(5) char b_bg, __zp(6) char b_fg)
fg_sum: {
    .label return = 7
    .label a_border = 2
    .label a_bg = 3
    .label a_fg = 8
    .label b_border = 4
    .label b_bg = 5
    .label b_fg = 6
    // a.fg+b.fg
    lda.z a_fg
    clc
    adc.z b_fg
    // return a.fg+b.fg;
    sta.z return
    // }
    rts
}
main: {
    // char sum1 = fg_sum(a, b)
    lda a
    sta.z fg_sum.a_border
    lda a+OFFSET_STRUCT_COLS_BG
    sta.z fg_sum.a_bg
    lda a+OFFSET_STRUCT_COLS_FG
    sta.z fg_sum.a_fg
    lda b
    sta.z fg_sum.b_border
    lda b+OFFSET_STRUCT_COLS_BG
    sta.z fg_sum.b_bg
    lda b+OFFSET_STRUCT_COLS_FG
    sta.z fg_sum.b_fg
    jsr fg_sum
    lda.z fg_sum.return
    // *COLS = sum1
    sta COLS
    // d = b
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda b-1,y
    sta d-1,y
    dey
    bne !-
    // char sum2 = fg_sum(c, d)
    lda c
    sta.z fg_sum.a_border
    lda c+OFFSET_STRUCT_COLS_BG
    sta.z fg_sum.a_bg
    lda c+OFFSET_STRUCT_COLS_FG
    sta.z fg_sum.a_fg
    lda d
    sta.z fg_sum.b_border
    lda d+OFFSET_STRUCT_COLS_BG
    sta.z fg_sum.b_bg
    lda d+OFFSET_STRUCT_COLS_FG
    sta.z fg_sum.b_fg
    jsr fg_sum
    lda.z fg_sum.return
    // *COLS = sum2
    sta COLS
    // }
    rts
}
.segment Data
  a: .byte 1, 2, 3
  b: .byte 3, 4, 6
  c: .byte 5, 6, 7
  d: .fill SIZEOF_STRUCT_COLS, 0
