ldy #1
lda ({c1}),y
bne !+
dey
lda ({c1}),y
cmp #{c2}
beq {la1}
!:
