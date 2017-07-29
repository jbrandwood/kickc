BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  lda #0
  sta 3
  lda #100
main__B1:
  sta 2
  dec 2
  lda 2
  bne main__B2
main__Breturn:
  rts
main__B2:
  lda 2
  cmp #50
  beq !+
  bcs main__B4
!:
main__B5:
  dec 3
main__B1_from_B5:
  lda 2
  jmp main__B1
main__B4:
  inc 3
main__B1_from_B4:
  lda 2
  jmp main__B1
