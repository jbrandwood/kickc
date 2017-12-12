  LDA {z1}
  CMP #{c1}
  BEQ !+
  BCS !++
!:
  LDA #0
  JMP !++
!:
  LDA #$ff
!:
  STA {zpbo1}
