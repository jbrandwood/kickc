  LDA {zpby1}
  CMP #{coby1}
  BEQ !f+
  BCS !t+
!f:
  LDA #0
  JMP !d+
!t:
  LDA #$ff
!d:
  STA {zpbo1}