BBEGIN:
  jsr main
BEND:
main:
addpoint_from_main:
  lda #$1
  sta $2
  ldy #$5
  lda #$0
  sta $8
  lda #$5
  jsr addpoint
main__B3:
addpoint_from_B3:
  lda #$2
  sta $2
  ldy #$8
  lda #$f
  jsr addpoint
main__B4:
addpoint_from_B4:
  lda #$3
  sta $2
  ldy #$e
  lda #$6
  jsr addpoint
main__B5:
addpoint_from_B5:
  lda #$4
  sta $2
  ldy #$2
  lda #$22
  jsr addpoint
main__B6:
addpoint_from_B6:
  lda #$5
  sta $2
  ldy #$11
  lda #$15
  jsr addpoint
main__B7:
addpoint_from_B7:
  lda #$7
  sta $2
  ldy #$16
  lda #$1f
  jsr addpoint
main__B8:
  jsr initscreen
main__B1:
  jsr render
main__B10:
  jsr animate
main__B11:
  jmp main__B1
main__Breturn:
  rts
animate:
  lda $1000
  clc
  adc #$1
  sta $1000
  lda $1000
  cmp #$28
  beq animate__B1
animate__B2:
  lda $1100
  clc
  adc #$1
  sta $1100
  lda $1100
  cmp #$19
  beq animate__B3
animate__B4:
  ldx $1001
  dex
  stx $1001
  lda $1001
  cmp #$ff
  beq animate__B5
animate__B6:
  lda $1102
  clc
  adc #$1
  sta $1102
  lda $1102
  cmp #$19
  beq animate__B7
animate__B8:
  ldx $1103
  dex
  stx $1103
  lda $1103
  cmp #$ff
  beq animate__B9
animate__Breturn:
  rts
animate__B9:
  lda #$19
  sta $1103
  lda $1003
  clc
  adc #$7
  sta $1003
  lda $1003
  cmp #$28
  bcs animate__B11
  jmp animate__Breturn
animate__B11:
  lda $1003
  sec
  sbc #$28
  sta $1003
  jmp animate__Breturn
animate__B7:
  lda #$0
  sta $1102
  jmp animate__B8
animate__B5:
  lda #$28
  sta $1001
  jmp animate__B6
animate__B3:
  lda #$0
  sta $1100
  jmp animate__B4
animate__B1:
  lda #$0
  sta $1000
  jmp animate__B2
render:
render__B1_from_render:
  lda #<$d800
  sta $3
  lda #>$d800
  sta $3+$1
  lda #$0
  sta $2
render__B1_from_B3:
render__B1:
render__B2_from_B1:
  lda #$0
  sta $5
render__B2_from_B5:
render__B2:
  lda $5
  sta $9
  lda $2
  sta $a
  jsr findcol
render__B5:
  tya
  ldy $5
  sta ($3),y
  inc $5
  lda $5
  cmp #$28
  bcc render__B2_from_B5
render__B3:
  lda $3
  clc
  adc #$28
  sta $3
  bcc !+
  inc $3+$1
!:
  inc $2
  lda $2
  cmp #$19
  bcc render__B1_from_B3
render__Breturn:
  rts
findcol:
findcol__B1_from_findcol:
  ldy #$0
  lda #$ff
  sta $6
  ldx #$0
findcol__B1_from_B13:
findcol__B1:
  lda $1000,x
  sta $7
  lda $1100,x
  sta $b
  lda $9
  cmp $7
  beq findcol__B2
findcol__B3:
  lda $9
  cmp $7
  bcc findcol__B6
findcol__B7:
  lda $9
  sec
  sbc $7
  sta $7
findcol__B8_from_B7:
findcol__B8:
  lda $a
  cmp $b
  bcc findcol__B9
findcol__B10:
  lda $a
  sec
  sbc $b
  clc
  adc $7
findcol__B11_from_B10:
findcol__B11:
  cmp $6
  bcc findcol__B12
findcol__B13_from_B11:
findcol__B13:
  inx
  cpx $8
  bcc findcol__B1_from_B13
findcol__Breturn_from_B13:
  jmp findcol__Breturn
findcol__Breturn_from_B2:
  ldy #$0
findcol__Breturn:
  rts
findcol__B12:
  ldy $1200,x
  sta $6
findcol__B13_from_B12:
  jmp findcol__B13
findcol__B9:
  lda $b
  sec
  sbc $a
  clc
  adc $7
findcol__B11_from_B9:
  jmp findcol__B11
findcol__B6:
  lda $7
  sec
  sbc $9
  sta $7
findcol__B8_from_B6:
  jmp findcol__B8
findcol__B2:
  lda $a
  cmp $b
  beq findcol__Breturn_from_B2
  jmp findcol__B3
initscreen:
initscreen__B1_from_initscreen:
  lda #<$400
  sta $3
  lda #>$400
  sta $3+$1
initscreen__B1_from_B1:
initscreen__B1:
  ldy #$0
  lda #$e6
  sta ($3),y
  inc $3
  bne !+
  inc $3+$1
!:
  lda $3+$1
  cmp #>$7e8
  bcc initscreen__B1_from_B1
  bne !+
  lda $3
  cmp #<$7e8
  bcc initscreen__B1_from_B1
!:
initscreen__Breturn:
  rts
addpoint:
  ldx $8
  sta $1000,x
  tya
  ldy $8
  sta $1100,y
  lda $2
  ldx $8
  sta $1200,x
  inc $8
addpoint__Breturn:
  rts
