BBEGIN:
B1_from_BBEGIN:
  ldx #$5
B1_from_B1:
B1:
  txa
  clc
  adc #$4
  sta $1100,x
  inx
  cpx #$a
  bcc B1_from_B1
BEND:
