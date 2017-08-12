  lda #$0
  ldx #$a
b1:
  cpx #$5
  beq !+
  bcs b2
!:
b3:
  dex
  cpx #$0
  bne b1
b2:
  stx $ff
  clc
  adc $ff
  jmp b3
