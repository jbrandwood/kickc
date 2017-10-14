  .const STAR = $51
  .const SCREEN = $400
  jsr main
main: {
    .const x1 = $27
    .const y1 = $18
    .const xd = x1-$0
    .const yd = y1-$0
    .label x = 4
    .label cursor = 2
    .label y = 5
    lda #$0
    sta y
    ldx #yd/$2
    lda #$0
    sta x
    lda #<(SCREEN+($0*$28))+$0
    sta cursor
    lda #>(SCREEN+($0*$28))+$0
    sta cursor+$1
  b1:
    ldy #$0
    lda #STAR
    sta (cursor),y
    inc x
    inc cursor
    bne !+
    inc cursor+$1
  !:
    txa
    clc
    adc #yd
    tax
    cpx #xd
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
    sbc #xd
    tax
  b2:
    lda x
    cmp #x1+$1
    bcc b1
    rts
}
