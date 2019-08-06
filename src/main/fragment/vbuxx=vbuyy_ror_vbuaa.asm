cpy #0
beq !e+
!l:
ror
dey
bne !l-
!e:
sty $ff
ldx $ff
