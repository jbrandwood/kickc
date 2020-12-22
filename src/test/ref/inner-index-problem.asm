// Demonstrates a problem with inner indexes into arrays where the elemt size>1
  // Commodore 64 PRG executable file
.file [name="inner-index-problem.prg", type="prg", segments="Program"]
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
    // for(char i=0;i<5;i++)
    cpx #5
    bcc __b2
    // }
    rts
  __b2:
    // x[i] += ( v[i] += 5 )
    txa
    asl
    tay
    // v[i] += 5
    clc
    lda v,y
    adc #5
    sta v,y
    lda v+1,y
    adc #0
    sta v+1,y
    // x[i] += ( v[i] += 5 )
    clc
    lda x,y
    adc v,y
    sta x,y
    lda x+1,y
    adc v+1,y
    sta x+1,y
    // for(char i=0;i<5;i++)
    inx
    jmp __b1
}
.segment Data
  v: .fill 2*5, 0
  x: .fill 2*5, 0
