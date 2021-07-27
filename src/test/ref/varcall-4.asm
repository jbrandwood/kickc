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
// fg_sum(byte zp(3) a_border, byte zp(4) a_bg, byte zp(5) a_fg, byte zp(6) b_border, byte zp(7) b_bg, byte zp(8) b_fg)
fg_sum: {
    .label return = 2
    .label a_border = 3
    .label a_bg = 4
    .label a_fg = 5
    .label b_border = 6
    .label b_bg = 7
    .label b_fg = 8
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
