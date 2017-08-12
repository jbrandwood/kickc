bbegin:
b1_from_bbegin:
  lda #$0
  ldx #$a
b1_from_b3:
b1:
  cpx #$5
  beq !+
  bcs b2
!:
b3_from_b1:
b3:
  dex
  cpx #$0
  bne b1_from_b3
bend:
b2:
  stx $ff
  clc
  adc $ff
b3_from_b2:
  jmp b3
