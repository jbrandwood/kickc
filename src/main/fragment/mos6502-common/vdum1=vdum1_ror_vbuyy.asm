cpy #0
beq !e+
!:
lsr {m1}+3
ror {m1}+2
ror {m1}+1
ror {m1}
dey
bne !-
!e:
