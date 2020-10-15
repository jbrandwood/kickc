ldy #1
lda ({c1}),y
bne {la1}
dey
lda ({c1}),y
cmp #{c2}
bne {la1}
