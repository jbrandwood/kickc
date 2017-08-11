BBEGIN:
  jsr main
BEND:
main:
inccnt_from_main:
  ldy #0
  ldx #0
  jsr inccnt
main__B1:
  sta 1024
  inx
inccnt_from_B1:
  jsr inccnt
main__B2:
  sta 1025
main__Breturn:
  rts
inccnt:
  inx
  iny
  txa
inccnt__Breturn:
  rts
