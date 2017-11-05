  LDA {zpby1}
  CMP #{coby1}
  BEQ !+
  BCS !++
!:
  LDA #0
  JMP !++
!:
  LDA #$ff
!:
  STA {zpbo1}