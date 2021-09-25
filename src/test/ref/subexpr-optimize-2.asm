// Tests optimization of identical sub-expressions
  // Commodore 64 PRG executable file
.file [name="subexpr-optimize-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = 2
    .label i = 4
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #0
    sta.z i
  __b1:
    // i+1
    lda.z i
    clc
    adc #1
    // (i+1)*2
    asl
    // *screen++ = (i+1)*2
    ldy #0
    sta (screen),y
    // *screen++ = (i+1)*2;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // i+1
    lda.z i
    clc
    adc #1
    // (i+1)*2
    asl
    // *screen++ = (i+1)*2
    ldy #0
    sta (screen),y
    // *screen++ = (i+1)*2;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( byte i: 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
