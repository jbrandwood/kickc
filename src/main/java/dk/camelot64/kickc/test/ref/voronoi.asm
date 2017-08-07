BBEGIN:
  jsr main
BEND:
main:
addpoint_from_main:
  lda #1
  sta 2
  ldx #5
  ldy #0
  lda #5
  jsr addpoint
main__B3:
addpoint_from_B3:
  lda #2
  sta 2
  ldx #8
  ldy #1
  lda #15
  jsr addpoint
main__B4:
addpoint_from_B4:
  lda #3
  sta 2
  ldx #14
  ldy #2
  lda #6
  jsr addpoint
main__B5:
addpoint_from_B5:
  lda #4
  sta 2
  ldx #2
  ldy #3
  lda #34
  jsr addpoint
main__B6:
addpoint_from_B6:
  lda #5
  sta 2
  ldx #17
  ldy #4
  lda #21
  jsr addpoint
main__B7:
addpoint_from_B7:
  lda #7
  sta 2
  ldx #22
  ldy #5
  lda #31
  jsr addpoint
main__B1:
  jsr render
main__B9:
  jsr animate
main__B10:
  jmp main__B1
main__Breturn:
  rts
animate:
  lda 4096
  clc
  adc #1
  sta 4096
  lda 4096
  cmp #40
  beq animate__B1
animate__B2:
  lda 4352
  clc
  adc #1
  sta 4352
  lda 4352
  cmp #25
  beq animate__B3
animate__B4:
  ldx 4097
  dex
  stx 4097
  lda 4097
  cmp #255
  beq animate__B5
animate__B6:
  lda 4354
  clc
  adc #1
  sta 4354
  lda 4354
  cmp #25
  beq animate__B7
animate__B8:
  ldx 4355
  dex
  stx 4355
  lda 4355
  cmp #255
  beq animate__B9
animate__Breturn:
  rts
animate__B9:
  lda #25
  sta 4355
  lda 4099
  clc
  adc #7
  sta 4099
  lda 4099
  cmp #40
  bcs animate__B11
  jmp animate__Breturn
animate__B11:
  lda 4099
  sec
  sbc #40
  sta 4099
  jmp animate__Breturn
animate__B7:
  lda #0
  sta 4354
  jmp animate__B8
animate__B5:
  lda #40
  sta 4097
  jmp animate__B6
animate__B3:
  lda #0
  sta 4352
  jmp animate__B4
animate__B1:
  lda #0
  sta 4096
  jmp animate__B2
render:
render__B1_from_render:
  lda #<1024
  sta 5
  lda #>1024
  sta 5+1
  lda #<55296
  sta 3
  lda #>55296
  sta 3+1
  lda #0
  sta 2
render__B1_from_B3:
render__B1:
render__B2_from_B1:
  lda #0
  sta 7
render__B2_from_B5:
render__B2:
  lda 7
  sta 11
  lda 2
  sta 12
  jsr findcol
render__B5:
  lda 10
  ldy 7
  sta (3),y
  lda #230
  ldy 7
  sta (5),y
  inc 7
  lda 7
  cmp #40
  bcc render__B2_from_B5
render__B3:
  lda 5
  clc
  adc #40
  sta 5
  bcc !+
  inc 5+1
!:
  lda 3
  clc
  adc #40
  sta 3
  bcc !+
  inc 3+1
!:
  inc 2
  lda 2
  cmp #25
  bcc render__B1_from_B3
render__Breturn:
  rts
findcol:
findcol__B1_from_findcol:
  lda #0
  sta 10
  lda #255
  sta 8
  ldy #0
findcol__B1_from_B13:
findcol__B1:
  lda 4096,y
  ldx 4352,y
  cmp 11
  beq findcol__B2
findcol__B3:
  cmp 11
  bcs findcol__B6
findcol__B7:
  eor #255
  sec
  adc 11
  sta 9
findcol__B8_from_B7:
findcol__B8:
  cpx 12
  bcs findcol__B9
findcol__B10:
  stx 255
  lda 12
  sec
  sbc 255
  clc
  adc 9
  tax
findcol__B11_from_B10:
findcol__B11:
  cpx 8
  bcc findcol__B12
findcol__B13_from_B11:
findcol__B13:
  iny
  cpy #6
  bcc findcol__B1_from_B13
findcol__Breturn_from_B13:
  jmp findcol__Breturn
findcol__Breturn_from_B2:
  lda #0
  sta 10
findcol__Breturn:
  rts
findcol__B12:
  lda 4608,y
  sta 10
  stx 8
findcol__B13_from_B12:
  jmp findcol__B13
findcol__B9:
  txa
  sec
  sbc 12
  clc
  adc 9
  tax
findcol__B11_from_B9:
  jmp findcol__B11
findcol__B6:
  sec
  sbc 11
  sta 9
findcol__B8_from_B6:
  jmp findcol__B8
findcol__B2:
  cpx 12
  beq findcol__Breturn_from_B2
  jmp findcol__B3
addpoint:
  sta 4096,y
  txa
  sta 4352,y
  lda 2
  sta 4608,y
addpoint__Breturn:
  rts
