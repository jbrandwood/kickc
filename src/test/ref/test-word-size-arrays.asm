.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label _2 = 4
    .label _4 = 6
    .label _6 = 8
    .label line = 2
    .label _7 = 6
    .label _8 = 4
    .label _9 = 8
    lda #<0
    sta.z line
    sta.z line+1
  b2:
    ldx #0
  b4:
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
    cpx #$28
    bcc b4
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    lda.z line+1
    cmp #>$28*$18
    bcc b2
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc b2
  !:
    ldx #0
  b7:
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
  // Cleare the bottom line
    cpx #$28
    bcc b7
    rts
}
