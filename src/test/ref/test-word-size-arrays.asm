.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label __2 = 6
    .label __4 = 8
    .label __6 = 4
    .label line = 2
    .label __7 = 8
    .label __8 = 6
    .label __9 = 4
    lda #<0
    sta.z line
    sta.z line+1
  __b1:
    lda.z line+1
    cmp #>$28*$18
    bcc b1
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc b1
  !:
    ldx #0
  // Cleare the bottom line
  __b5:
    cpx #$28
    bcc __b6
    rts
  __b6:
    txa
    clc
    adc.z line
    sta.z __6
    lda #0
    adc.z line+1
    sta.z __6+1
    clc
    lda.z __9
    adc #<screen
    sta.z __9
    lda.z __9+1
    adc #>screen
    sta.z __9+1
    lda #' '
    ldy #0
    sta (__9),y
    inx
    jmp __b5
  b1:
    ldx #0
  __b2:
    cpx #$28
    bcc __b3
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp __b1
  __b3:
    txa
    clc
    adc.z line
    sta.z __2
    lda #0
    adc.z line+1
    sta.z __2+1
    txa
    clc
    adc.z line
    sta.z __4
    lda #0
    adc.z line+1
    sta.z __4+1
    clc
    lda.z __7
    adc #<screen+$28
    sta.z __7
    lda.z __7+1
    adc #>screen+$28
    sta.z __7+1
    clc
    lda.z __8
    adc #<screen
    sta.z __8
    lda.z __8+1
    adc #>screen
    sta.z __8+1
    ldy #0
    lda (__7),y
    sta (__8),y
    inx
    jmp __b2
}
