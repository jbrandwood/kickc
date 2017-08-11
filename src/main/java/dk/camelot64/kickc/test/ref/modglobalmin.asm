BBEGIN:
  jsr main
BEND:
main:
inccnt_from_main:
  ldx #0
  jsr inccnt
main__B1:
  stx 1024
  inx
inccnt_from_B1:
  jsr inccnt
main__B2:
  inx
  stx 1025
main__Breturn:
  rts
inccnt:
  inx
inccnt__Breturn:
  rts
