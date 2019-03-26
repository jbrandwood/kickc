.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const STAR = $51
  .label SCREEN = $400
main: {
    .const x0 = 4
    .const y0 = 4
    .const x1 = $27
    .const y1 = $18
    .const xd = x1-x0
    .const yd = y1-y0
    .label x = 4
    .label cursor = 2
    .label y = 5
    lda #y0
    sta y
    ldx #yd/2
    lda #x0
    sta x
    lda #<SCREEN+y0*$28+x0
    sta cursor
    lda #>SCREEN+y0*$28+x0
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
    axs #-yd
    cpx #xd
    bcc b2
    inc y
    lda #$28
    clc
    adc cursor
    sta cursor
    bcc !+
    inc cursor+1
  !:
    txa
    axs #xd
  b2:
    lda x
    cmp #x1+1
    bcc b1
    rts
}
