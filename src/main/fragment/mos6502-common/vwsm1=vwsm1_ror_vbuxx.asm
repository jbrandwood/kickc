cpx #0
beq !e+
!:
lda {m1}+1
cmp #$80
ror {m1}+1
ror {m1}
dex
bne !-
!e:
