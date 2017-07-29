BBEGIN:
B1_from_BBEGIN:
  lda #0
  sta 3
  lda #10
  sta 2
B1_from_B3:
B1:
  lda 2
  cmp #5
  beq !+
  bcs B2
!:
B3_from_B1:
B3:
  dec 2
  lda 2
  bne B1_from_B3
BEND:
B2:
  lda 3
  clc
  adc 2
B3_from_B2:
  sta 3
  jmp B3
