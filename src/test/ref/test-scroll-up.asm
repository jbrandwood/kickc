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
    sta line
    sta line+1
  b1:
    lda line+1
    cmp #>$28*$18
    bcc b2
    bne !+
    lda line
    cmp #<$28*$18
    bcc b2
  !:
    rts
  b2:
    lda line
    sta l2
    lda line+1
    sta l2+1
    ldx #0
  b3:
    cpx #$28
    bcc b4
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    jmp b1
  b4:
    lda l2
    clc
    adc #<screen+$28
    sta _3
    lda l2+1
    adc #>screen+$28
    sta _3+1
    lda l2
    clc
    adc #<screen
    sta _4
    lda l2+1
    adc #>screen
    sta _4+1
    ldy #0
    lda (_3),y
    sta (_4),y
    inc l2
    bne !+
    inc l2+1
  !:
    inx
    jmp b3
}
scrollup2: {
    .label line1 = 3
    .label line2 = 9
    .label l = 2
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
    .label _2 = 7
    .label _4 = 9
    .label line = 5
    .label _5 = 9
    .label _6 = 7
    lda #<0
    sta line
    sta line+1
  b1:
    lda line+1
    cmp #>$28*$18
    bcc b4
    bne !+
    lda line
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
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    jmp b1
  b3:
    txa
    clc
    adc line
    sta _2
    lda #0
    adc line+1
    sta _2+1
    txa
    clc
    adc line
    sta _4
    lda #0
    adc line+1
    sta _4+1
    clc
    lda _5
    adc #<screen+$28
    sta _5
    lda _5+1
    adc #>screen+$28
    sta _5+1
    clc
    lda _6
    adc #<screen
    sta _6
    lda _6+1
    adc #>screen
    sta _6+1
    ldy #0
    lda (_5),y
    sta (_6),y
    inx
    jmp b2
}
