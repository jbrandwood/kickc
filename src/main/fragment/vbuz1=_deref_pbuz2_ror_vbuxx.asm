cpx #0
beq !e+
ldy #0
lda ({z2}),y
!:
ror
dex
bne !-
sta {z1}
!e:
