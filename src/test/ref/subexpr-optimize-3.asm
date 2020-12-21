// Tests optimization of identical sub-expressions
  // Commodore 64 PRG executable file
.file [name="subexpr-optimize-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label __4 = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    // i*2
    txa
    asl
    // i*2+i
    stx.z $ff
    clc
    adc.z $ff
    sta.z __4
    // i*2+i+3
    lda #3
    clc
    adc.z __4
    // *screen++ = i*2+i+3
    ldy #0
    sta (screen),y
    // *screen++ = i*2+i+3;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // i*2+i+3
    lda #3
    clc
    adc.z __4
    // *screen++ = i*2+i+3
    ldy #0
    sta (screen),y
    // *screen++ = i*2+i+3;
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
}
