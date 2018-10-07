.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
  jsr main
main: {
    jsr prepare
  b1:
    ldx #$19
  b3:
    lda RASTER
    cmp #$fe
    bne b3
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    dex
    cpx #0
    bne b3
    jsr flip
    jsr plot
    jmp b1
}
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
    lda line
    clc
    adc #$28
    sta line
    bcc !+
    inc line+1
  !:
    dec y
    lda y
    bne b1
    rts
}
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
    clc
    adc #$10
    tax
    dec c
    lda c
    bne b2
    dex
    dec r
    lda r
    bne b1
    ldx #0
  b3:
    lda buffer2,x
    sta buffer1,x
    inx
    cpx #0
    bne b3
    rts
}
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
