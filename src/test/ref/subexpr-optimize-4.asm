// Tests optimization of identical sub-expressions
  // Commodore 64 PRG executable file
.file [name="subexpr-optimize-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label __6 = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    // i&1
    lda #1
    sax.z __6
    // (i&1)?i+3:i*4
    lda.z __6
    bne __b2
    txa
    asl
    asl
  __b4:
    // *screen++ = (i&1)?i+3:i*4
    ldy #0
    sta (screen),y
    // *screen++ = (i&1)?i+3:i*4;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // (i&1)?i+3:i*4
    lda.z __6
    bne __b5
    txa
    asl
    asl
  __b7:
    // *screen++ = (i&1)?i+3:i*4
    ldy #0
    sta (screen),y
    // *screen++ = (i&1)?i+3:i*4;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
  __b5:
    // (i&1)?i+3:i*4
    txa
    clc
    adc #3
    jmp __b7
  __b2:
    txa
    clc
    adc #3
    jmp __b4
}
