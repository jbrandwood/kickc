BBEGIN:
B1_from_BBEGIN:
  lda #0
  sta 5
  lda #10
  sta 4
  jmp B1
B1_from_B3:
  lda 6
  sta 5
  lda 3
  sta 4
B1:
  lda 4
  cmp #5
  beq !+
  bcs B2
!:
B3_from_B1:
  lda 5
  sta 6
B3:
  lda 4
  sta 3
  dec 3
  lda 3
  bne B1_from_B3
BEND:
B2:
  lda 5
  clc
  adc 4
  sta 2
B3_from_B2:
  lda 2
  sta 6
  jmp B3
