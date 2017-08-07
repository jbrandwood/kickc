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
  jmp main__B1
main__Breturn:
  rts
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
  ldy #0
render__B2_from_B5:
render__B2:
  sty 10
  lda 2
  sta 11
  jsr findcol
render__B5:
  lda 9
  sta (3),y
  lda #230
  sta (5),y
  iny
  cpy #40
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
  sta 9
  lda #255
  sta 7
  ldx #0
findcol__B1_from_B13:
findcol__B1:
  lda 4096,x
  sta 8
  lda 4352,x
  sta 12
  lda 10
  cmp 8
  beq findcol__B2
findcol__B3:
  lda 10
  cmp 8
  bcc findcol__B6
findcol__B7:
  lda 10
  sec
  sbc 8
  sta 8
findcol__B8_from_B7:
findcol__B8:
  lda 11
  cmp 12
  bcc findcol__B9
findcol__B10:
  lda 11
  sec
  sbc 12
  clc
  adc 8
  sta 8
findcol__B11_from_B10:
findcol__B11:
  lda 8
  cmp 7
  bcc findcol__B12
findcol__B13_from_B11:
findcol__B13:
  inx
  cpx #6
  bcc findcol__B1_from_B13
findcol__Breturn_from_B13:
  jmp findcol__Breturn
findcol__Breturn_from_B2:
  lda #0
  sta 9
findcol__Breturn:
  rts
findcol__B12:
  lda 4608,x
  sta 9
  lda 8
  sta 7
findcol__B13_from_B12:
  jmp findcol__B13
findcol__B9:
  lda 12
  sec
  sbc 11
  clc
  adc 8
  sta 8
findcol__B11_from_B9:
  jmp findcol__B11
findcol__B6:
  lda 8
  sec
  sbc 10
  sta 8
findcol__B8_from_B6:
  jmp findcol__B8
findcol__B2:
  lda 11
  cmp 12
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
