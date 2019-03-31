.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
main: {
    jsr prepare
  b3:
    ldx #$19
  b1:
    lda #$fe
    cmp RASTER
    bne b1
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    dex
    cpx #0
    bne b1
    jsr flip
    jsr plot
    jmp b3
}
// Plot buffer on screen
plot: {
    .label line = 2
    .label y = 4
    lda #$10
    sta y
    lda #<SCREEN+5*$28+$c
    sta line
    lda #>SCREEN+5*$28+$c
    sta line+1
    ldx #0
  b1:
    ldy #0
  b2:
    lda buffer1,x
    sta (line),y
    inx
    iny
    cpy #$10
    bcc b2
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    dec y
    lda y
    cmp #0
    bne b1
    rts
}
// Flip buffer
flip: {
    .label c = 5
    .label r = 4
    lda #$10
    sta r
    ldx #$f
    ldy #0
  b1:
    lda #$10
    sta c
  b2:
    lda buffer1,y
    sta buffer2,x
    iny
    txa
    axs #-[$10]
    dec c
    lda c
    cmp #0
    bne b2
    dex
    dec r
    lda r
    cmp #0
    bne b1
    ldx #0
  b4:
    lda buffer2,x
    sta buffer1,x
    inx
    cpx #0
    bne b4
    rts
}
// Prepare buffer
prepare: {
    ldx #0
  b1:
    txa
    sta buffer1,x
    inx
    cpx #0
    bne b1
    rts
}
  buffer1: .fill $10*$10, 0
  buffer2: .fill $10*$10, 0
