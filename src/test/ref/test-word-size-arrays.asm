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
    sta line
    sta line+1
  b2:
    ldx #0
  b4:
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
    bcc b4
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    lda line+1
    cmp #>$28*$18
    bcc b2
    bne !+
    lda line
    cmp #<$28*$18
    bcc b2
  !:
    ldx #0
  b7:
    txa
    clc
    adc line
    sta _6
    lda #0
    adc line+1
    sta _6+1
    clc
    lda _9
    adc #<screen
    sta _9
    lda _9+1
    adc #>screen
    sta _9+1
    lda #' '
    ldy #0
    sta (_9),y
    inx
  // Cleare the bottom line
    cpx #$28
    bcc b7
    rts
}
