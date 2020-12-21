// Test __varcall calling convention
// Larger type parameter & return value
  // Commodore 64 PRG executable file
.file [name="varcall-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BGCOL = $d020
.segment Code
// plus(signed word zp(2) a, signed word zp(4) b)
plus: {
    .label return = 2
    .label a = 2
    .label b = 4
    .label __0 = 2
    // a+b
    lda.z __0
    clc
    adc.z b
    sta.z __0
    lda.z __0+1
    adc.z b+1
    sta.z __0+1
    // return a+b;
    // }
    rts
}
main: {
    .label a = 4
    .label a_1 = 2
    // *BGCOL = a
    lda #<$102
    sta BGCOL
    lda #>$102
    sta BGCOL+1
    // plus(a, 0x0203)
    lda #<$102
    sta.z plus.a
    lda #>$102
    sta.z plus.a+1
    lda #<$203
    sta.z plus.b
    lda #>$203
    sta.z plus.b+1
    jsr plus
    // a = plus(a, 0x0203)
    lda.z plus.return
    sta.z a
    lda.z plus.return+1
    sta.z a+1
    // *BGCOL = a
    lda.z a
    sta BGCOL
    lda.z a+1
    sta BGCOL+1
    // plus(a, a)
    lda.z a
    sta.z plus.a
    lda.z a+1
    sta.z plus.a+1
    jsr plus
    // a = plus(a, a)
    // *BGCOL = a
    lda.z a_1
    sta BGCOL
    lda.z a_1+1
    sta BGCOL+1
    // }
    rts
}
