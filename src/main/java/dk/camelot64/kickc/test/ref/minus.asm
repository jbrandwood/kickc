BBEGIN:
B1_from_BBEGIN:
  ldx #5
B1_from_B1:
B1:
  txa
  clc
  adc #4
  sta 4352,x
  inx
  cpx #10
  bcc B1_from_B1
BEND:
