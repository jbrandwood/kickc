// Test array index pointer rewriting
// 8bit array with 8bit index
// Fibonacci calculation uses adjacent indices inside the loop
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // fibs[0] = 0
    lda #0
    sta fibs
    // fibs[1] = 1
    lda #1
    sta fibs+1
    ldx #0
  __b1:
    // for(char i=0;i<NUM_FIBS-2;i++)
    cpx #$19-2
    bcc __b2
    // }
    rts
  __b2:
    // fibs[i]+fibs[i+1]
    lda fibs,x
    clc
    adc fibs+1,x
    // fibs[i+2] = fibs[i]+fibs[i+1]
    sta fibs+2,x
    // for(char i=0;i<NUM_FIBS-2;i++)
    inx
    jmp __b1
}
.segment Data
  fibs: .fill $19, 0
