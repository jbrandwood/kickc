  jsr main
main: {
    .label x = 4
    .label cursor = 2
    .label y = 5
    lda #$0
    sta y
    ldx #$c
    lda #$0
    sta x
    lda #<$400
    sta cursor
    lda #>$400
    sta cursor+$1
  b1:
    ldy #$0
    lda #$51
    sta (cursor),y
    inc x
    inc cursor
    bne !+
    inc cursor+$1
  !:
    txa
    clc
    adc #$18
    tax
    cpx #$27
    bcc b2
    inc y
    lda cursor
    clc
    adc #$28
    sta cursor
    bcc !+
    inc cursor+$1
  !:
    txa
    sec
    sbc #$27
    tax
  b2:
    lda x
    cmp #$28
    bcc b1
    rts
}
