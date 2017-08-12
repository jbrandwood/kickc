BBEGIN:
B1_from_BBEGIN:
  lda #$0
  sta $5
  ldx #$c
  lda #$0
  sta $4
  lda #<$400
  sta $2
  lda #>$400
  sta $2+$1
B1_from_B3:
B1:
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
  bcs B2
B3_from_B1:
B3:
  lda $4
  cmp #$28
  bcc B1_from_B3
BEND:
B2:
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
B3_from_B2:
  jmp B3
