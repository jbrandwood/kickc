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
    .label _5 = $d
    .label _6 = $f
    .label l2_4 = 4
    lda #0
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
    sta _5
    lda l2_2+1
    adc #>screen+$28
    sta _5+1
    lda l2_2
    clc
    adc #<screen
    sta _6
    lda l2_2+1
    adc #>screen
    sta _6+1
    ldy #0
    lda (_5),y
    sta (_6),y
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
    .label line1 = 9
    .label line2 = 7
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
    .label _0 = $11
    .label _2 = $13
    .label line = $b
    .label _7 = $13
    .label _8 = $11
    lda #0
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
    lda _7
    adc #<screen+$28
    sta _7
    lda _7+1
    adc #>screen+$28
    sta _7+1
    clc
    lda _8
    adc #<screen
    sta _8
    lda _8+1
    adc #>screen
    sta _8+1
    ldy #0
    lda (_7),y
    sta (_8),y
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
