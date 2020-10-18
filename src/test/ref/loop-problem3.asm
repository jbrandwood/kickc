// A loop that compiles to a wrong sequence - skipping the initilization
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label sc = 2
  __b3:
    lda #<$400
    sta.z sc
    lda #>$400
    sta.z sc+1
  __b1:
    // for(char* sc = 0x0400;sc<0x0800; sc++)
    lda.z sc+1
    cmp #>$800
    bcc __b2
    bne !+
    lda.z sc
    cmp #<$800
    bcc __b2
  !:
    jmp __b3
  __b2:
    // (*sc)++;
    ldy #0
    lda (sc),y
    clc
    adc #1
    sta (sc),y
    // for(char* sc = 0x0400;sc<0x0800; sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
