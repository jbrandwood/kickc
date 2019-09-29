.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
main: {
    jsr prepare
  b1:
    ldx #$19
  __b1:
    lda #$fe
    cmp RASTER
    bne __b1
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    dex
    cpx #0
    bne __b1
    jsr flip
    jsr plot
    jmp b1
}
// Plot buffer on screen
plot: {
    .label line = 2
    .label y = 4
    lda #$10
    sta.z y
    lda #<SCREEN+5*$28+$c
    sta.z line
    lda #>SCREEN+5*$28+$c
    sta.z line+1
    ldx #0
  __b1:
    ldy #0
  __b2:
    cpy #$10
    bcc __b3
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    dec.z y
    lda.z y
    cmp #0
    bne __b1
    rts
  __b3:
    lda buffer1,x
    sta (line),y
    inx
    iny
    jmp __b2
}
// Flip buffer
flip: {
    .label c = 5
    .label r = 4
    lda #$10
    sta.z r
    ldx #$f
    ldy #0
  __b1:
    lda #$10
    sta.z c
  __b2:
    lda buffer1,y
    sta buffer2,x
    iny
    txa
    axs #-[$10]
    dec.z c
    lda.z c
    cmp #0
    bne __b2
    dex
    dec.z r
    lda.z r
    cmp #0
    bne __b1
    ldx #0
  __b4:
    lda buffer2,x
    sta buffer1,x
    inx
    cpx #0
    bne __b4
    rts
}
// Prepare buffer
prepare: {
    ldx #0
  __b1:
    txa
    sta buffer1,x
    inx
    cpx #0
    bne __b1
    rts
}
  buffer1: .fill $10*$10, 0
  buffer2: .fill $10*$10, 0
