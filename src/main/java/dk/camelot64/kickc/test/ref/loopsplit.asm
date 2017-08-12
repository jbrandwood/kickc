BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  ldy #$0
  ldx #$64
main__B1:
  dex
  cpx #$0
  bne main__B2
main__Breturn:
  rts
main__B2:
  cpx #$32
  beq !+
  bcs main__B4
!:
main__B5:
  dey
main__B1_from_B5:
  jmp main__B1
main__B4:
  iny
main__B1_from_B4:
  jmp main__B1
