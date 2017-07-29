BBEGIN:
  jsr main
BEND:
main:
  jsr prepare
main__B3_from_main:
  lda #25
  sta 2
  jmp main__B3
main__B3_from_B11:
  lda #25
  sta 2
main__B3_from_B3:
main__B3_from_B6:
main__B3:
  lda 53266
  sta 5
  lda 5
  cmp #254
  bne main__B3_from_B3
main__B4:
  lda 53266
  sta 5
  lda 5
  cmp #255
  bne main__B4
main__B6:
  dec 2
  lda 2
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
  sta 2
  lda #<1236
  sta 3
  lda #>1236
  sta 3+1
  lda #0
  sta 5
plot__B1_from_B3:
plot__B1:
plot__B2_from_B1:
  lda #0
  sta 6
plot__B2_from_B2:
plot__B2:
  ldy 5
  lda 4096,y
  sta 7
  lda 7
  ldy 6
  sta (3),y
  inc 5
  inc 6
  lda 6
  cmp #16
  bcc plot__B2_from_B2
plot__B3:
  lda 3
  clc
  adc #40
  sta 3
  bcc !+
  inc 3+1
!:
  dec 2
  lda 2
  bne plot__B1_from_B3
plot__Breturn:
  rts
flip:
flip__B1_from_flip:
  lda #16
  sta 2
  lda #15
  sta 6
  lda #0
  sta 5
flip__B1_from_B4:
flip__B1:
flip__B2_from_B1:
  lda #16
  sta 7
flip__B2_from_B2:
flip__B2:
  ldy 5
  lda 4096,y
  sta 8
  lda 8
  ldy 6
  sta 4352,y
  inc 5
  lda 6
  clc
  adc #16
  sta 6
  dec 7
  lda 7
  bne flip__B2_from_B2
flip__B4:
  dec 6
  dec 2
  lda 2
  bne flip__B1_from_B4
flip__B3_from_B4:
  lda #0
  sta 2
flip__B3_from_B3:
flip__B3:
  ldy 2
  lda 4352,y
  sta 5
  lda 5
  ldy 2
  sta 4096,y
  inc 2
  lda 2
  bne flip__B3_from_B3
flip__Breturn:
  rts
prepare:
prepare__B1_from_prepare:
  lda #0
  sta 2
prepare__B1_from_B1:
prepare__B1:
  ldy 2
  tya
  sta 4096,y
  inc 2
  lda 2
  bne prepare__B1_from_B1
prepare__Breturn:
  rts
