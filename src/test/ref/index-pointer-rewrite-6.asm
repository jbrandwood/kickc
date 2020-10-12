// Test array index pointer rewriting
// 8bit array with 16bit index
// Fibonacci calculation uses adjacent indices inside the loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label i = 2
    .label __4 = 4
    .label __5 = 6
    .label __6 = 8
    // fibs[0] = 0
    lda #0
    sta fibs
    // fibs[1] = 1
    lda #1
    sta fibs+1
    lda #<0
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
    // fibs[i]+fibs[i+1]
    clc
    lda.z i
    adc #<fibs
    sta.z __4
    lda.z i+1
    adc #>fibs
    sta.z __4+1
    clc
    lda.z i
    adc #<fibs+1
    sta.z __5
    lda.z i+1
    adc #>fibs+1
    sta.z __5+1
    ldy #0
    lda (__4),y
    clc
    adc (__5),y
    tax
    // fibs[i+2] = fibs[i]+fibs[i+1]
    clc
    lda.z i
    adc #<fibs+2
    sta.z __6
    lda.z i+1
    adc #>fibs+2
    sta.z __6+1
    txa
    sta (__6),y
    // for(unsigned short i=0;i<NUM_FIBS-2;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
  fibs: .fill $19, 0
