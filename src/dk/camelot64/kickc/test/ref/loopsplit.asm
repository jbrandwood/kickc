BBEGIN:
B1_from_BBEGIN:
  lda #0
  sta 3
  lda #100
  sta 2
B1:
  dec 2
  lda 2
BEND:
B2:
  lda 2
  cmp #50
  beq !+
  bcs B4
!:
B5:
  dec 3
B1_from_B5:
  jmp B1
B4:
  inc 3
B1_from_B4:
  jmp B1
