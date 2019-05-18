.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const STAR = $51
    .label screen = $400
    .const x0 = 0
    .const y0 = 0
    .const x1 = $27
    .const y1 = $18
    .const xd = x1-x0
    .const yd = y1-y0
    .label x = 4
    .label idx = 2
    .label y = 5
    .label _16 = 6
    lda #y0
    sta y
    ldx #yd/2
    lda #x0
    sta x
    lda #<0
    sta idx
    sta idx+1
  b1:
    lda idx
    clc
    adc #<screen
    sta _16
    lda idx+1
    adc #>screen
    sta _16+1
    lda #STAR
    ldy #0
    sta (_16),y
    inc x
    inc idx
    bne !+
    inc idx+1
  !:
    txa
    axs #-[yd]
    cpx #xd
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
    txa
    axs #xd
  b2:
    lda x
    cmp #x1+1
    bcc b1
    rts
}
