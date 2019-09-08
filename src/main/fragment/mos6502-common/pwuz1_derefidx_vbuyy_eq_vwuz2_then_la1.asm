lda ({z1}),y
cmp {z2}
bne !+
iny
lda ({z1}),y
cmp {z2}+1
beq {la1}
!: