BBEGIN:
B1_from_BBEGIN:
  lda #5
  sta 2
B1_from_B1:
B1:
  lda 2
  clc
  adc #4
  sta 3
  lda 3
  ldx 2
  sta 4352,x
  inc 2
  lda 2
  cmp #10
  bcc B1_from_B1
BEND:
