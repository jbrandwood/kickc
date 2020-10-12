// Tests that array-indexing by a word variable is turned into pointer addition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label i = 2
    .label __1 = 4
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for( word i=0;i<1000;i+=40)
    lda.z i+1
    cmp #>$3e8
    bcc __b2
    bne !+
    lda.z i
    cmp #<$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // screen[i] = 'a'
    clc
    lda.z i
    adc #<screen
    sta.z __1
    lda.z i+1
    adc #>screen
    sta.z __1+1
    lda #'a'
    ldy #0
    sta (__1),y
    // i+=40
    lda #$28
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    jmp __b1
}
