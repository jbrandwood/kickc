// Fill screen using an word-based index
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i = 2
    .label __1 = 4
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<1000; i++)
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
    // SCREEN[i] = ' '
    clc
    lda.z i
    adc #<SCREEN
    sta.z __1
    lda.z i+1
    adc #>SCREEN
    sta.z __1+1
    lda #' '
    ldy #0
    sta (__1),y
    // for(unsigned int i=0;i<1000; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
