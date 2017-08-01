BBEGIN:
  jsr main
BEND:
main:
  jsr prepare
main__B3_from_main:
  ldx #25
  jmp main__B3
main__B3_from_B11:
  ldx #25
main__B3_from_B3:
main__B3_from_B6:
main__B3:
  lda 53266
  cmp #254
  bne main__B3_from_B3
main__B4:
  lda 53266
  cmp #255
  bne main__B4
main__B6:
  dex
  cpx #0
  bne main__B3_from_B6
main__B7:
  jsr flip
main__B10:
  jsr plot
main__B11:
  jmp main__B3_from_B11
main__Breturn:
  rts
plot:
plot__B1_from_plot:
  lda #16
  sta 4
  lda #<1236
  sta 2
  lda #>1236
  sta 2+1
  ldx #0
plot__B1_from_B3:
plot__B1:
plot__B2_from_B1:
  ldy #0
plot__B2_from_B2:
plot__B2:
  lda 4096,x
  sta (2),y
  inx
  iny
  cpy #16
  bcc plot__B2_from_B2
plot__B3:
  lda 2
  clc
  adc #40
  sta 2
  bcc !+
  inc 2+1
!:
  dec 4
  lda 4
  bne plot__B1_from_B3
plot__Breturn:
  rts
flip:
flip__B1_from_flip:
  lda #16
  sta 4
  ldy #15
  ldx #0
flip__B1_from_B4:
flip__B1:
flip__B2_from_B1:
  lda #16
  sta 5
flip__B2_from_B2:
flip__B2:
  lda 4096,x
  sta 4352,y
  inx
  tya
  clc
  adc #16
  tay
  dec 5
  lda 5
  bne flip__B2_from_B2
flip__B4:
  dey
  dec 4
  lda 4
  bne flip__B1_from_B4
flip__B3_from_B4:
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
