BBEGIN:
  lda #0
  sta 4352
  lda #1
  sta 4353
B1_from_BBEGIN:
  lda #0
  sta 2
B1_from_B1:
B1:
  ldx 2
  lda 4352,x
  sta 3
  ldx 2
  lda 4353,x
  sta 4
  lda 3
  clc
  adc 4
  sta 3
  lda 3
  ldx 2
  sta 4354,x
  inc 2
  lda 2
  cmp #15
  bcc B1_from_B1
BEND:
