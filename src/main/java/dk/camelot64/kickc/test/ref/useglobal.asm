BBEGIN:
  jsr main
BEND:
main:
  lda #$1
  sta $400
main__Breturn:
  rts
