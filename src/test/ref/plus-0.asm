// Tests elimination of plus 0
  // Commodore 64 PRG executable file
.file [name="plus-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // fill((byte*)$400,'a')
    ldx #'a'
    lda #<$400
    sta.z fill.screen
    lda #>$400
    sta.z fill.screen+1
    jsr fill
    // fill((byte*)$2000,'b')
    ldx #'b'
    lda #<$2000
    sta.z fill.screen
    lda #>$2000
    sta.z fill.screen+1
    jsr fill
    // }
    rts
}
// void fill(__zp(6) char *screen, __register(X) char ch)
fill: {
    .label screen = 6
    .label __5 = 2
    .label __7 = 4
    ldy #0
  __b2:
    // (screen+j*40)[i] = ch
    txa
    sta (screen),y
    // screen+j*40
    lda #1*$28
    clc
    adc.z screen
    sta.z __5
    lda #0
    adc.z screen+1
    sta.z __5+1
    // (screen+j*40)[i] = ch
    txa
    sta (__5),y
    // screen+j*40
    lda #2*$28
    clc
    adc.z screen
    sta.z __7
    lda #0
    adc.z screen+1
    sta.z __7+1
    // (screen+j*40)[i] = ch
    txa
    sta (__7),y
    // for(byte i: 0..39)
    iny
    cpy #$28
    bne __b2
    // }
    rts
}
