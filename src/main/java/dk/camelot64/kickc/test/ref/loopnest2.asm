BBEGIN:
  jsr main
BEND:
main:
main__B1_from_main:
  ldx #100
main__B1_from_B3:
main__B1:
main__B2_from_B1:
  ldy #100
main__B2_from_B5:
main__B2:
  jsr nest1
main__B5:
  dey
  cpy #0
  bne main__B2_from_B5
main__B3:
  dex
  cpx #0
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
  sta 4
nest2__B1_from_B3:
nest2__B1:
nest2__B2_from_B1:
  lda #100
nest2__B2_from_B2:
nest2__B2:
  sta 1024
  sec
  sbc #1
  cmp #0
  bne nest2__B2_from_B2
nest2__B3:
  dec 4
  lda 4
  bne nest2__B1_from_B3
nest2__Breturn:
  rts
