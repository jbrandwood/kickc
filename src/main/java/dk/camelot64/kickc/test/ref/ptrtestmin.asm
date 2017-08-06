BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  ldx #2
main__B1:
  cpx #10
  bcc main__B2
main__Breturn:
  rts
main__B2:
  lda 1024,x
  inx
main__B1_from_B2:
  jmp main__B1
