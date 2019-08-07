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
    .label x = 4
    .label idx = 2
    .label y = 5
    .label _15 = 6
    lda #y0
    sta.z y
    ldx #y1/2
    lda #x0
    sta.z x
    lda #<0
    sta.z idx
    sta.z idx+1
  b1:
    lda.z idx
    clc
    adc #<screen
    sta.z _15
    lda.z idx+1
    adc #>screen
    sta.z _15+1
    lda #STAR
    ldy #0
    sta (_15),y
    inc.z x
    inc.z idx
    bne !+
    inc.z idx+1
  !:
    txa
    axs #-[y1]
    cpx #x1
    bcc b2
    beq b2
    inc.z y
    lda #$28
    clc
    adc.z idx
    sta.z idx
    bcc !+
    inc.z idx+1
  !:
    txa
    axs #x1
  b2:
    lda.z x
    cmp #x1+1
    bcc b1
    rts
}
