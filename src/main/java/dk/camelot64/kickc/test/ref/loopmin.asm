BBEGIN:
B1_from_BBEGIN:
  lda #0
  ldx #10
B1_from_B3:
B1:
  cpx #5
  beq !+
  bcs B2
!:
B3_from_B1:
B3:
  dex
  cpx #0
  bne B1_from_B3
BEND:
B2:
  stx 255
  clc
  adc 255
B3_from_B2:
  jmp B3
