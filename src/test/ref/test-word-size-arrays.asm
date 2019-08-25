.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label _2 = 6
    .label _4 = 8
    .label _6 = 4
    .label line = 2
    .label _7 = 8
    .label _8 = 6
    .label _9 = 4
    lda #<0
    sta.z line
    sta.z line+1
  b1:
    lda.z line+1
    cmp #>$28*$18
    bcc b4
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc b4
  !:
    ldx #0
  // Cleare the bottom line
  b5:
    cpx #$28
    bcc b6
    rts
  b6:
    txa
    clc
    adc.z line
    sta.z _6
    lda #0
    adc.z line+1
    sta.z _6+1
    clc
    lda.z _9
    adc #<screen
    sta.z _9
    lda.z _9+1
    adc #>screen
    sta.z _9+1
    lda #' '
    ldy #0
    sta (_9),y
    inx
    jmp b5
  b4:
    ldx #0
  b2:
    cpx #$28
    bcc b3
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp b1
  b3:
    txa
    clc
    adc.z line
    sta.z _2
    lda #0
    adc.z line+1
    sta.z _2+1
    txa
    clc
    adc.z line
    sta.z _4
    lda #0
    adc.z line+1
    sta.z _4+1
    clc
    lda.z _7
    adc #<screen+$28
    sta.z _7
    lda.z _7+1
    adc #>screen+$28
    sta.z _7+1
    clc
    lda.z _8
    adc #<screen
    sta.z _8
    lda.z _8+1
    adc #>screen
    sta.z _8+1
    ldy #0
    lda (_7),y
    sta (_8),y
    inx
    jmp b2
}
