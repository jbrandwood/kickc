cpy #0
cpy #0
beq !e+
!:
asl {z1}
rol {z1}+1
rol {z1}+2
rol {z1}+3
dey
bne !-
!e: