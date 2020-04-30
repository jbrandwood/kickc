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
    sta.z y
    ldx #yd/2
    lda #x0
    sta.z x
    lda #<SCREEN+y0*$28+x0
    sta.z cursor
    lda #>SCREEN+y0*$28+x0
    sta.z cursor+1
  __b1:
    // *cursor = STAR
    lda #STAR
    ldy #0
    sta (cursor),y
    // x = x + 1
    inc.z x
    // cursor = cursor + 1
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    // e = e+yd
    txa
    axs #-[yd]
    // if(xd<=e)
    cpx #xd
    bcc __b2
    // y = y+1
    inc.z y
    // cursor = cursor + 40
    lda #$28
    clc
    adc.z cursor
    sta.z cursor
    bcc !+
    inc.z cursor+1
  !:
    // e = e - xd
    txa
    axs #xd
  __b2:
    // while (x<(x1+1))
    lda.z x
    cmp #x1+1
    bcc __b1
    // }
    rts
}
