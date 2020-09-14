lda {c1},y
cmp #0
bne !+
lda {c1}+1,y
cmp #0
beq {la1}
!: