bbegin:
b1_from_bbegin:
  lda #$0
  sta $5
  ldx #$c
  lda #$0
  sta $4
  lda #<$400
  sta $2
  lda #>$400
  sta $2+$1
b1_from_b3:
b1:
  ldy #$0
  lda #$51
  sta ($2),y
  inc $4
  inc $2
  bne !+
  inc $2+$1
!:
  txa
  clc
  adc #$18
  tax
  cpx #$27
  bcs b2
b3_from_b1:
b3:
  lda $4
  cmp #$28
  bcc b1_from_b3
bend:
b2:
  inc $5
  lda $2
  clc
  adc #$28
  sta $2
  bcc !+
  inc $2+$1
!:
  txa
  sec
  sbc #$27
  tax
b3_from_b2:
  jmp b3
