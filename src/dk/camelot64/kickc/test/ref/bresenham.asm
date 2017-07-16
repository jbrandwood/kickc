BBEGIN:
B1_from_BBEGIN:
  lda #0
  sta 14
  lda #12
  sta 13
  lda #0
  sta 12
  lda #<1024
  sta 10
  lda #>1024
  sta 10+1
  jmp B1
B1_from_B3:
  lda 18
  sta 14
  lda 15
  sta 13
  lda 2
  sta 12
  lda 16
  sta 10
  lda 16+1
  sta 10+1
B1:
  ldy #0
  lda #81
  sta (10),y
  lda 12
  clc
  adc #1
  sta 2
  lda 10
  clc
  adc #1
  sta 3
  lda 10+1
  adc #0
  sta 3+1
  lda 13
  clc
  adc #24
  sta 5
  lda #39
  cmp 5
  bcc B2
B3_from_B1:
  lda 14
  sta 18
  lda 3
  sta 16
  lda 3+1
  sta 16+1
  lda 5
  sta 15
B3:
  lda 2
  cmp #40
  bcc B1_from_B3
BEND:
B2:
  lda 14
  clc
  adc #1
  sta 6
  lda #40
  clc
  adc 3
  sta 7
  lda #0
  adc 3+1
  sta 7+1
  lda 5
  sec
  sbc #39
  sta 9
B3_from_B2:
  lda 6
  sta 18
  lda 7
  sta 16
  lda 7+1
  sta 16+1
  lda 9
  sta 15
  jmp B3
