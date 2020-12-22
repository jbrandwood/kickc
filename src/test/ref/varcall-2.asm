// Test __varcall calling convention
// Return value
  // Commodore 64 PRG executable file
.file [name="varcall-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BGCOL = $d021
.segment Code
// plus(byte zp(3) a, byte zp(4) b)
plus: {
    .label return = 2
    .label a = 3
    .label b = 4
    // a+b
    lda.z a
    clc
    adc.z b
    // return a+b;
    sta.z return
    // }
    rts
}
main: {
    // *BGCOL = a
    lda #1
    sta BGCOL
    // plus(a, 1)
    sta.z plus.a
    sta.z plus.b
    jsr plus
    // a = plus(a, 1)
    lda.z plus.return
    // *BGCOL = a
    sta BGCOL
    // plus(a, a)
    sta.z plus.a
    sta.z plus.b
    jsr plus
    // a = plus(a, a)
    lda.z plus.return
    // *BGCOL = a
    sta BGCOL
    // }
    rts
}
