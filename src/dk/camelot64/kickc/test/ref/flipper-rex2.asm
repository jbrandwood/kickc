BBEGIN:
  jsr prepare
B2_from_BBEGIN:
  ldx #25
  jmp B2
B2_from_B20:
  ldx #25
B2_from_B6:
B2:
B3:
  lda 53266
  cmp #254
  bne B3
B4:
  lda 53266
  cmp #255
  bne B4
B6:
  dex
  cpx #0
  bne B2_from_B6
B7:
  jsr flip
B19:
  jsr plot
B20:
  jmp B2_from_B20
BEND:
plot:
plot__B1_from_plot:
  lda #16
  sta 100
  ldx #0
  lda #<1236
  sta 101
  lda #>1236
  sta 101+1
plot__B1_from_B15:
plot__B1:
plot__B2_from_B1:
  ldy #0
plot__B2_from_B2:
plot__B2:
  lda 4096,x
  sta (101),y
  inx
  iny
  cpy #16
  bcc plot__B2_from_B2
B15:
  lda 101
  clc
  adc #40
  sta 101
  bcc !+
  inc 101+1
!:
  dec 100
  lda 100
  bne plot__B1_from_B15
plot__Breturn:
  rts
flip:
flip__B1_from_flip:
  lda #16
  sta 104
  ldx #0
  ldy #15
flip__B1_from_B11:
flip__B1:
flip__B2_from_B1:
  lda #16
  sta 103
flip__B2_from_B2:
flip__B2:
  lda 4096,x
  sta 4352,y
  inx
  tya
  clc
  adc #16
  tay
  dec 103
  lda 103
  bne flip__B2_from_B2
B11:
  dey
  dec 104
  lda 104
  bne flip__B1_from_B11
flip__B3_from_B11:
  ldx #0
flip__B3_from_B3:
flip__B3:
  lda 4352,x
  sta 4096,x
  inx
  cpx #0
  bne flip__B3_from_B3
flip__Breturn:
  rts
prepare:
prepare__B1_from_prepare:
  ldx #0
prepare__B1_from_B1:
prepare__B1:
  txa
  sta 4096,x
  inx
  cpx #0
  bne prepare__B1_from_B1
prepare__Breturn:
  rts
