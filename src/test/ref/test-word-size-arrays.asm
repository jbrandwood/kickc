.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label _0 = 4
    .label _2 = 6
    .label _5 = 8
    .label line = 2
    .label _7 = 6
    .label _8 = 4
    .label _9 = 8
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
    ldx #0
  // Cleare the bottom line
  b4:
    txa
    clc
    adc line
    sta _5
    lda #0
    adc line+1
    sta _5+1
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
    cpx #$28
    bcc b4
    rts
}
