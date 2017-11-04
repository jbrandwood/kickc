.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const STAR = $51
  .const SCREEN = $400
  jsr main
main: {
    .const x1 = $27
    .const y1 = $18
    .const xd = x1-4
    .const yd = y1-4
    .label cursor = 2
    .label e = 4
    .label y = 5
    lda #4
    sta y
    lda #yd/2
    sta e
    ldx #4
    lda #<SCREEN+4*$28+4
    sta cursor
    lda #>SCREEN+4*$28+4
    sta cursor+1
  b1:
    ldy #0
    lda #STAR
    sta (cursor),y
    inx
    inc cursor
    bne !+
    inc cursor+1
  !:
    lda e
    clc
    adc #yd
    sta e
    lda #xd
    cmp e
    bcs b2
    inc y
    lda cursor
    clc
    adc #$28
    sta cursor
    bcc !+
    inc cursor+1
  !:
    sec
    sbc #xd
    sta e
  b2:
    cpx #x1+1
    bcc b1
    rts
}
