  ldx #$5
b1:
  txa
  clc
  adc #$4
  sta $1100,x
  inx
  cpx #$a
  bcc b1
