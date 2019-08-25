// Tests different ways of scrolling up the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    jsr scrollup1
    jsr scrollup2
    jsr scrollup3
    rts
}
scrollup3: {
    .label l2 = 3
    .label line = 9
    .label _3 = 5
    .label _4 = 7
    lda #<0
    sta.z line
    sta.z line+1
  b1:
    lda.z line+1
    cmp #>$28*$18
    bcc b2
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc b2
  !:
    rts
  b2:
    lda.z line
    sta.z l2
    lda.z line+1
    sta.z l2+1
    ldx #0
  b3:
    cpx #$28
    bcc b4
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp b1
  b4:
    lda.z l2
    clc
    adc #<screen+$28
    sta.z _3
    lda.z l2+1
    adc #>screen+$28
    sta.z _3+1
    lda.z l2
    clc
    adc #<screen
    sta.z _4
    lda.z l2+1
    adc #>screen
    sta.z _4+1
    ldy #0
    lda (_3),y
    sta (_4),y
    inc.z l2
    bne !+
    inc.z l2+1
  !:
    inx
    jmp b3
}
scrollup2: {
    .label line1 = 3
    .label line2 = 9
    .label l = 2
    lda #0
    sta.z l
    lda #<screen
    sta.z line1
    lda #>screen
    sta.z line1+1
    lda #<screen+$28
    sta.z line2
    lda #>screen+$28
    sta.z line2+1
  b1:
    ldx #0
  b2:
    ldy #0
    lda (line2),y
    sta (line1),y
    inc.z line1
    bne !+
    inc.z line1+1
  !:
    inc.z line2
    bne !+
    inc.z line2+1
  !:
    inx
    cpx #$28
    bne b2
    inc.z l
    lda #$18
    cmp.z l
    bne b1
    rts
}
scrollup1: {
    .label _2 = 7
    .label _4 = 9
    .label line = 5
    .label _5 = 9
    .label _6 = 7
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
    rts
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
    lda.z _5
    adc #<screen+$28
    sta.z _5
    lda.z _5+1
    adc #>screen+$28
    sta.z _5+1
    clc
    lda.z _6
    adc #<screen
    sta.z _6
    lda.z _6+1
    adc #>screen
    sta.z _6+1
    ldy #0
    lda (_5),y
    sta (_6),y
    inx
    jmp b2
}
