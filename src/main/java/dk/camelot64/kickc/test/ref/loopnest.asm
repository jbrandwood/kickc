BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  ldx #100
main__B1_from_B3:
main__B1:
  jsr nest
main__B3:
  dex
  cpx #0
  bne main__B1_from_B3
main__Breturn:
  rts
nest:
nest__B1_from_nest:
  ldy #100
nest__B1_from_B1:
nest__B1:
  sty 1024
  dey
  cpy #0
  bne nest__B1_from_B1
nest__Breturn:
  rts
