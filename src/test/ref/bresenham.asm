.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STAR = $51
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
    sta.z y
    ldx #yd/2
    lda #x0
    sta.z x
    lda #<SCREEN+y0*$28+x0
    sta.z cursor
    lda #>SCREEN+y0*$28+x0
    sta.z cursor+1
  __b1:
    lda #STAR
    ldy #0
    sta (cursor),y
    inc.z x
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    txa
    axs #-[yd]
    cpx #xd
    bcc __b2
    inc.z y
    lda #$28
    clc
    adc.z cursor
    sta.z cursor
    bcc !+
    inc.z cursor+1
  !:
    txa
    axs #xd
  __b2:
    lda.z x
    cmp #x1+1
    bcc __b1
    rts
}
