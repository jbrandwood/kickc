// Test array index pointer rewriting
// 16bit array with 8bit index
// Fibonacci calculation uses adjacent indices inside the loop
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label __1 = 3
    .label __3 = 4
    .label i = 2
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
  __b1:
    // for(char i=0;i<NUM_FIBS-2;i++)
    lda.z i
    cmp #$19-2
    bcc __b2
    // }
    rts
  __b2:
    // i+2
    lda.z i
    clc
    adc #2
    sta.z __1
    // i+1
    ldx.z i
    inx
    // fibs[i]+fibs[i+1]
    lda.z i
    asl
    tay
    txa
    asl
    tax
    clc
    lda fibs,x
    adc fibs,y
    sta.z __3
    lda fibs+1,x
    adc fibs+1,y
    sta.z __3+1
    // fibs[i+2] = fibs[i]+fibs[i+1]
    lda.z __1
    asl
    tay
    lda.z __3
    sta fibs,y
    lda.z __3+1
    sta fibs+1,y
    // for(char i=0;i<NUM_FIBS-2;i++)
    inc.z i
    jmp __b1
}
.segment Data
  fibs: .fill 2*$19, 0
