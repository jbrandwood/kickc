BBEGIN:
  lda #0
  sta 4352
  lda #1
  sta 4353
B1_from_BBEGIN:
  ldx #0
B1_from_B1:
B1:
  lda 4352,x
  sta 2
  lda 4353,x
  clc
  adc 2
  sta 4354,x
  inx
  cpx #15
  bcc B1_from_B1
BEND:
