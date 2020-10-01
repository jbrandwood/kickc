// Test array index pointer rewriting
// 8bit array with 8bit index
// Fibonacci calculation uses adjacent indices inside the loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  fibs: .fill $19, 0
