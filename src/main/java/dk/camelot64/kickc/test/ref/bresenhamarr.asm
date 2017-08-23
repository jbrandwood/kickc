  .label idx = 2
  .label y = 4
  lda #$0
  sta y
  ldy #$c
  ldx #$0
  lda #$0
  sta idx
  lda #$0
  sta idx+$1
b1:
  lda #<$400
  clc
  adc idx
  sta !s++$1
  lda #>$400
  adc idx+$1
  sta !s++$2
  lda #$51
!s:
  sta $400
  inx
  inc idx
  bne !+
  inc idx+$1
!:
  tya
  clc
  adc #$18
  tay
  cpy #$27
  bcc b2
  inc y
  lda idx
  clc
  adc #<$28
  sta idx
  bcc !+
  inc idx+$1
!:
  tya
  sec
  sbc #$27
  tay
b2:
  cpx #$28
  bcc b1
