// Test __varcall calling convention
// Struct of struct parameter value
  // Commodore 64 PRG executable file
.file [name="varcall-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label COLS = $d020
.segment Code
main: {
    .const a_normal_border = 1
    .const a_normal_bg = 2
    .const a_error_border = 3
    .const a_error_bg = 4
    .const b_normal_border = 5
    .const b_normal_bg = 6
    .const b_error_border = 7
    .const b_error_bg = 8
    .const c_normal_border = 9
    .const c_normal_bg = $a
    .const c_error_border = $b
    .const c_error_bg = $c
    // plus(a, b)
    lda #a_normal_border
    sta.z plus.a_normal_border
    lda #a_normal_bg
    sta.z plus.a_normal_bg
    lda #a_error_border
    sta.z plus.a_error_border
    lda #a_error_bg
    sta.z plus.a_error_bg
    lda #b_normal_border
    sta.z plus.b_normal_border
    lda #b_normal_bg
    sta.z plus.b_normal_bg
    lda #b_error_border
    sta.z plus.b_error_border
    lda #b_error_bg
    sta.z plus.b_error_bg
    jsr plus
    lda.z plus.return
    // *COLS = plus(a, b)
    sta COLS
    // plus(b, c)
    lda #b_normal_border
    sta.z plus.a_normal_border
    lda #b_normal_bg
    sta.z plus.a_normal_bg
    lda #b_error_border
    sta.z plus.a_error_border
    lda #b_error_bg
    sta.z plus.a_error_bg
    lda #c_normal_border
    sta.z plus.b_normal_border
    lda #c_normal_bg
    sta.z plus.b_normal_bg
    lda #c_error_border
    sta.z plus.b_error_border
    lda #c_error_bg
    sta.z plus.b_error_bg
    jsr plus
    lda.z plus.return
    // *COLS = plus(b, c)
    sta COLS
    // }
    rts
}
// __zp(2) char plus(__zp($a) char a_normal_border, __zp(7) char a_normal_bg, __zp(8) char a_error_border, __zp(9) char a_error_bg, __zp(3) char b_normal_border, __zp(4) char b_normal_bg, __zp(5) char b_error_border, __zp(6) char b_error_bg)
plus: {
    .label return = 2
    .label a_normal_border = $a
    .label a_normal_bg = 7
    .label a_error_border = 8
    .label a_error_bg = 9
    .label b_normal_border = 3
    .label b_normal_bg = 4
    .label b_error_border = 5
    .label b_error_bg = 6
    // a.normal.border + b.normal.border
    lda.z a_normal_border
    clc
    adc.z b_normal_border
    // a.normal.border + b.normal.border + a.normal.bg
    clc
    adc.z a_normal_bg
    // a.normal.border + b.normal.border + a.normal.bg + b.normal.bg
    clc
    adc.z b_normal_bg
    // a.normal.border + b.normal.border + a.normal.bg + b.normal.bg + a.error.border
    clc
    adc.z a_error_border
    // a.normal.border + b.normal.border + a.normal.bg + b.normal.bg + a.error.border + b.error.border
    clc
    adc.z b_error_border
    // a.normal.border + b.normal.border + a.normal.bg + b.normal.bg + a.error.border + b.error.border + a.error.bg
    clc
    adc.z a_error_bg
    // a.normal.border + b.normal.border + a.normal.bg + b.normal.bg + a.error.border + b.error.border + a.error.bg + b.error.bg
    clc
    adc.z b_error_bg
    // return a.normal.border + b.normal.border + a.normal.bg + b.normal.bg + a.error.border + b.error.border + a.error.bg + b.error.bg;
    sta.z return
    // }
    rts
}
