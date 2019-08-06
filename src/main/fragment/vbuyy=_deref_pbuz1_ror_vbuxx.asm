cpx #0
beq !e+
ldy #0
lda ({z1}),y
!:
ror
dex
bne !-
tay
!e:
