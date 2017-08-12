BBEGIN:
  jsr main
BEND:
main:
  jsr prepare
main__B3_from_main:
  ldx #$19
  jmp main__B3
main__B3_from_B11:
  ldx #$19
main__B3_from_B3:
main__B3_from_B6:
main__B3:
  lda $d012
  cmp #$fe
  bne main__B3_from_B3
main__B4:
  lda $d012
  cmp #$ff
  bne main__B4
main__B6:
  dex
  cpx #$0
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
  lda #$10
  sta $4
  lda #<$4d4
  sta $2
  lda #>$4d4
  sta $2+$1
  ldx #$0
plot__B1_from_B3:
plot__B1:
plot__B2_from_B1:
  ldy #$0
plot__B2_from_B2:
plot__B2:
  lda $1000,x
  sta ($2),y
  inx
  iny
  cpy #$10
  bcc plot__B2_from_B2
plot__B3:
  lda $2
  clc
  adc #$28
  sta $2
  bcc !+
  inc $2+$1
!:
  dec $4
  lda $4
  bne plot__B1_from_B3
plot__Breturn:
  rts
flip:
flip__B1_from_flip:
  lda #$10
  sta $4
  ldy #$f
  ldx #$0
flip__B1_from_B4:
flip__B1:
flip__B2_from_B1:
  lda #$10
  sta $5
flip__B2_from_B2:
flip__B2:
  lda $1000,x
  sta $1100,y
  inx
  tya
  clc
  adc #$10
  tay
  dec $5
  lda $5
  bne flip__B2_from_B2
flip__B4:
  dey
  dec $4
  lda $4
  bne flip__B1_from_B4
flip__B3_from_B4:
  ldx #$0
flip__B3_from_B3:
flip__B3:
  lda $1100,x
  sta $1000,x
  inx
  cpx #$0
  bne flip__B3_from_B3
flip__Breturn:
  rts
prepare:
prepare__B1_from_prepare:
  ldx #$0
prepare__B1_from_B1:
prepare__B1:
  txa
  sta $1000,x
  inx
  cpx #$0
  bne prepare__B1_from_B1
prepare__Breturn:
  rts
