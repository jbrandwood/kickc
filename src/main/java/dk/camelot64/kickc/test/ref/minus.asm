  .const p = $1100
  ldx #5
b1:
  txa
  clc
  adc #2+2
  sta p,x
  inx
  cpx #$a
  bcc b1
