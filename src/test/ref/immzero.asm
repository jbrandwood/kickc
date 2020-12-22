// Tests that immediate zero values are reused - even when assigning to words
  // Commodore 64 PRG executable file
.file [name="immzero.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label w = 2
    ldx #0
    txa
    sta.z w
    sta.z w+1
  __b1:
    // w = w + j
    txa
    clc
    adc.z w
    sta.z w
    bcc !+
    inc.z w+1
  !:
    // for ( byte j : 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
