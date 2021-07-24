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
  .const SIZEOF_STRUCT_COLS = 3
  .const OFFSET_STRUCT_COLS_FG = 2
  .label COLS = $d020
.segment Code
// fg_sum(struct Cols zp(3) a, struct Cols zp(6) b)
fg_sum: {
    .label a = 3
    .label b = 6
    .label return = 2
    // a.fg+b.fg
    lda a+OFFSET_STRUCT_COLS_FG
    clc
    adc b+OFFSET_STRUCT_COLS_FG
    // return a.fg+b.fg;
    sta.z return
    // }
    rts
}
main: {
    // fg_sum(a, b)
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda a-1,y
    sta fg_sum.a-1,y
    dey
    bne !-
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda b-1,y
    sta fg_sum.b-1,y
    dey
    bne !-
    jsr fg_sum
    // char sum1 = fg_sum(a, b)
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
    // fg_sum(c, d)
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda c-1,y
    sta fg_sum.a-1,y
    dey
    bne !-
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda d-1,y
    sta fg_sum.b-1,y
    dey
    bne !-
    jsr fg_sum
    // char sum2 = fg_sum(c, d)
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
