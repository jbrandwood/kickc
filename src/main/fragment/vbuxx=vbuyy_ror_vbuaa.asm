cpy #0
beq !e+
!l:
cmp #$80
ror
dey
bne !l-
!e:
sty $ff
ldx $ff
