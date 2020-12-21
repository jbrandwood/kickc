// Test that memory alignment of arrays work
  // Commodore 64 PRG executable file
.file [name="mem-alignment.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    ldx #0
  __b1:
    // bs[i] = i
    txa
    sta bs,x
    // for( byte i: 0..255)
    inx
    cpx #0
    bne __b1
    ldy #0
    ldx #$ff
  __b2:
    // cs[i] = bs[j--]
    lda bs,x
    sta cs,y
    // cs[i] = bs[j--];
    dex
    // for( byte i: 0..255)
    iny
    cpy #0
    bne __b2
    // }
    rts
  .segment Data
    .align $100
    cs: .fill $100, 0
}
  .align $100
  bs: .fill $100, 0
