  // Commodore 64 PRG executable file
.file [name="zpptr.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label zpptr = $1000
    .label zpptr2 = 4
    .label w = 6
    .label i = 3
    .label j = 2
    lda #0
    sta.z j
  __b1:
    lda #0
    sta.z i
  __b2:
    ldx #0
  __b3:
    // byte* zpptr2 = zpptr+i
    lda.z i
    clc
    adc #<zpptr
    sta.z zpptr2
    lda #>zpptr
    adc #0
    sta.z zpptr2+1
    // word w = (word)j
    lda.z j
    sta.z w
    lda #0
    sta.z w+1
    // zpptr2 = zpptr2 + w
    lda.z zpptr2
    clc
    adc.z w
    sta.z zpptr2
    lda.z zpptr2+1
    adc.z w+1
    sta.z zpptr2+1
    // *zpptr2 = k
    txa
    ldy #0
    sta (zpptr2),y
    // for(byte k : 0..10)
    inx
    cpx #$b
    bne __b3
    // for(byte i : 0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b2
    // for(byte j : 0..10)
    inc.z j
    cmp.z j
    bne __b1
    // }
    rts
}
