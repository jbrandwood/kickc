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
    .label l2 = 2
    .label l2_1 = 4
    .label line = 2
    .label l2_2 = 4
    .label _4 = 7
    .label _5 = 9
    .label l2_4 = 4
    lda #<0
    sta l2
    sta l2+1
  b1:
    lda l2
    sta l2_4
    lda l2+1
    sta l2_4+1
    ldx #0
  b2:
    lda l2_2
    clc
    adc #<screen+$28
    sta _4
    lda l2_2+1
    adc #>screen+$28
    sta _4+1
    lda l2_2
    clc
    adc #<screen
    sta _5
    lda l2_2+1
    adc #>screen
    sta _5+1
    ldy #0
    lda (_4),y
    sta (_5),y
    inc l2_1
    bne !+
    inc l2_1+1
  !:
    inx
    cpx #$28
    bcc b2
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    lda line+1
    cmp #>$28*$18
    bcc b1
    bne !+
    lda line
    cmp #<$28*$18
    bcc b1
  !:
    rts
}
scrollup2: {
    .label line1 = 4
    .label line2 = 2
    .label l = 6
    lda #0
    sta l
    lda #<screen
    sta line1
    lda #>screen
    sta line1+1
    lda #<screen+$28
    sta line2
    lda #>screen+$28
    sta line2+1
  b1:
    ldx #0
  b2:
    ldy #0
    lda (line2),y
    sta (line1),y
    inc line1
    bne !+
    inc line1+1
  !:
    inc line2
    bne !+
    inc line2+1
  !:
    inx
    cpx #$28
    bne b2
    inc l
    lda #$18
    cmp l
    bne b1
    rts
}
scrollup1: {
    .label _0 = 4
    .label _2 = 7
    .label line = 2
    .label _6 = 7
    .label _7 = 4
    lda #<0
    sta line
    sta line+1
  b1:
    ldx #0
  b2:
    txa
    clc
    adc line
    sta _0
    lda #0
    adc line+1
    sta _0+1
    txa
    clc
    adc line
    sta _2
    lda #0
    adc line+1
    sta _2+1
    clc
    lda _6
    adc #<screen+$28
    sta _6
    lda _6+1
    adc #>screen+$28
    sta _6+1
    clc
    lda _7
    adc #<screen
    sta _7
    lda _7+1
    adc #>screen
    sta _7+1
    ldy #0
    lda (_6),y
    sta (_7),y
    inx
    cpx #$28
    bcc b2
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    lda line+1
    cmp #>$28*$18
    bcc b1
    bne !+
    lda line
    cmp #<$28*$18
    bcc b1
  !:
    rts
}
