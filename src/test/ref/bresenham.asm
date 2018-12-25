.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const STAR = $51
  .label SCREEN = $400
main: {
    .const x1 = $27
    .const y1 = $18
    .const xd = x1-4
    .const yd = y1-4
    .label x = 4
    .label cursor = 2
    .label y = 5
    lda #4
    sta y
    ldx #yd/2
    sta x
    lda #<SCREEN+4*$28+4
    sta cursor
    lda #>SCREEN+4*$28+4
    sta cursor+1
  b1:
    lda #STAR
    ldy #0
    sta (cursor),y
    inc x
    inc cursor
    bne !+
    inc cursor+1
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
    inc cursor+1
  !:
    txa
    sec
    sbc #xd
    tax
  b2:
    lda x
    cmp #x1+1
    bcc b1
    rts
}
