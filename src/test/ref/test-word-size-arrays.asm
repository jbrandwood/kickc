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
    ldx #0
  // Cleare the bottom line
  b5:
    cpx #$28
    bcc b6
    rts
  b6:
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
    jmp b5
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
    jmp b2
}
