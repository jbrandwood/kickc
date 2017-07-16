BBEGIN:
  jsr main
BEND:
main:
  jsr prepare
main__B2_from_main:
  ldx #25
  jmp main__B2
main__B2_from_B18:
  ldx #25
main__B2_from_B2:
main__B2:
main__B3:
  lda 53266
  cmp #254
  bne main__main__B3
main__B4:
  lda 53266
  cmp #255
  bne main__main__B4
B2:
  dex
  cpx #0
  bne main__B2_from_B2
B3:
  jsr flip
B17:
  jsr plot
B18:
  jmp main__B2_from_B18
main__Breturn:
  rts
plot:
plot__B1_from_plot:
  lda #16
  sta 100
  ldx #0
  lda #<1236
  sta 101
  lda #>1236
  sta 101+1
plot__B1_from_B12:
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
B12:
  lda 101
  clc
  adc #40
  sta 101
  bcc !+
  inc 101+1
!:
  dec 100
  lda 100
  bne plot__B1_from_B12
plot__Breturn:
  rts
flip:
flip__B1_from_flip:
  lda #16
  sta 104
  ldx #0
  ldy #15
flip__B1_from_B8:
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
B8:
  dey
  dec 104
  lda 104
  bne flip__B1_from_B8
flip__B3_from_B8:
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
