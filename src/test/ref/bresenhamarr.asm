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
    .label idx = 2
    .label y = 4
    lda #y0
    sta y
    ldx #yd/2
    ldy #x0
    lda #x0+y0*$28
    sta idx
    lda #0
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
    iny
    inc idx
    bne !+
    inc idx+1
  !:
    txa
    axs #-yd
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
    cpy #x1+1
    bcc b1
    rts
}
