BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  lda #100
  sta 2
main__B1_from_B3:
main__B1:
main__B2_from_B1:
  lda #100
  sta 3
main__B2_from_B5:
main__B2:
  jsr nest1
main__B5:
  dec 3
  lda 3
  bne main__B2_from_B5
main__B3:
  dec 2
  lda 2
  bne main__B1_from_B3
main__Breturn:
  rts
nest1:
nest1__B1_from_nest1:
  lda #100
  sta 2
nest1__B1_from_B3:
nest1__B1:
nest1__B2_from_B1:
  lda #100
  sta 3
nest1__B2_from_B5:
nest1__B2:
  jsr nest2
nest1__B5:
  dec 3
  lda 3
  bne nest1__B2_from_B5
nest1__B3:
  dec 2
  lda 2
  bne nest1__B1_from_B3
nest1__Breturn:
  rts
nest2:
nest2__B1_from_nest2:
  lda #100
  sta 2
nest2__B1_from_B3:
nest2__B1:
nest2__B2_from_B1:
  lda #100
  sta 3
nest2__B2_from_B2:
nest2__B2:
  lda 3
  sta 1024
  dec 3
  lda 3
  bne nest2__B2_from_B2
nest2__B3:
  dec 2
  lda 2
  bne nest2__B1_from_B3
nest2__Breturn:
  rts
