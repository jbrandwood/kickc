ldy {z2}
beq !e+
!:
asl {z1}
rol {z1}+1
dey
bne !-
!e: