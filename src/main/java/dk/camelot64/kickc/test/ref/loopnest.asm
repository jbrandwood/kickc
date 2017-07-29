BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  lda #100
  sta 2
main__B1_from_B3:
main__B1:
  jsr nest
main__B3:
  dec 2
  lda 2
  bne main__B1_from_B3
main__Breturn:
  rts
nest:
nest__B1_from_nest:
  lda #100
  sta 3
  jmp nest__B1
nest__B1_from_B1:
  sta 3
nest__B1:
  lda 3
  sta 1024
  lda 3
  sec
  sbc #1
  cmp #0
  bne nest__B1_from_B1
nest__Breturn:
  rts
