BBEGIN:
B1_from_BBEGIN:
  lda #5
  sta 5
  jmp B1
B1_from_B1:
  lda 4
  sta 5
B1:
  lda #2
  clc
  adc 5
  sta 2
  lda 2
  clc
  adc #2
  sta 3
  lda 3
  ldy 5
  sta 4352,y
  lda 5
  clc
  adc #1
  sta 4
  lda 4
  cmp #10
  bcc B1_from_B1
BEND:
