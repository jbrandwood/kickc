BBEGIN:
  jsr main
BEND:
main:
  lda #$0
  sta $1100
  lda #$1
  sta $1101
main__B1_from_main:
  ldx #$0
main__B1_from_B1:
main__B1:
  lda $1100,x
  clc
  adc $1101,x
  sta $1102,x
  inx
  cpx #$f
  bcc main__B1_from_B1
main__Breturn:
  rts
