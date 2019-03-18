.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const STAR = $51
    .label screen = $400
    .const x1 = $27
    .const y1 = $18
    .const xd = x1-0
    .const yd = y1-0
    .label idx = 2
    .label y = 4
    lda #0
    sta y
    ldy #yd/2
    tax
    sta idx
    sta idx+1
  b1:
    lda #<screen
    clc
    adc idx
    sta !++1
    lda #>screen
    adc idx+1
    sta !++2
    lda #STAR
  !:
    sta screen
    inx
    inc idx
    bne !+
    inc idx+1
  !:
    tya
    clc
    adc #yd
    tay
    cpy #xd
    bcc b2
    beq b2
    inc y
    lda #$28
    clc
    adc idx
    sta idx
    bcc !+
    inc idx+1
  !:
    tya
    sec
    sbc #xd
    tay
  b2:
    cpx #x1+1
    bcc b1
    rts
}
