// Test array index pointer rewriting
// 16bit array with 16bit index
// Fibonacci calculation uses adjacent indices inside the loop
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label __1 = 4
    .label __2 = 6
    .label __3 = 6
    .label __6 = 8
    .label __7 = 6
    .label __8 = 4
    .label i = 2
    .label __9 = 8
    .label __10 = 6
    .label __11 = 4
    // fibs[0] = 0
    lda #<0
    sta fibs
    sta fibs+1
    // fibs[1] = 1
    lda #<1
    sta fibs+1*SIZEOF_WORD
    lda #>1
    sta fibs+1*SIZEOF_WORD+1
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned short i=0;i<NUM_FIBS-2;i++)
    lda.z i+1
    bne !+
    lda.z i
    cmp #$19-2
    bcc __b2
  !:
    // }
    rts
  __b2:
    // i+2
    lda #2
    clc
    adc.z i
    sta.z __1
    lda #0
    adc.z i+1
    sta.z __1+1
    // i+1
    clc
    lda.z i
    adc #1
    sta.z __2
    lda.z i+1
    adc #0
    sta.z __2+1
    // fibs[i]+fibs[i+1]
    lda.z i
    asl
    sta.z __6
    lda.z i+1
    rol
    sta.z __6+1
    asl.z __7
    rol.z __7+1
    lda.z __9
    clc
    adc #<fibs
    sta.z __9
    lda.z __9+1
    adc #>fibs
    sta.z __9+1
    lda.z __10
    clc
    adc #<fibs
    sta.z __10
    lda.z __10+1
    adc #>fibs
    sta.z __10+1
    ldy #0
    clc
    lda (__3),y
    adc (__9),y
    pha
    iny
    lda (__3),y
    adc (__9),y
    sta.z __3+1
    pla
    sta.z __3
    // fibs[i+2] = fibs[i]+fibs[i+1]
    asl.z __8
    rol.z __8+1
    lda.z __11
    clc
    adc #<fibs
    sta.z __11
    lda.z __11+1
    adc #>fibs
    sta.z __11+1
    ldy #0
    lda.z __3
    sta (__11),y
    iny
    lda.z __3+1
    sta (__11),y
    // for(unsigned short i=0;i<NUM_FIBS-2;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
.segment Data
  fibs: .fill 2*$19, 0
