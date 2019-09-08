sec
ldy #0
lda ({z2}),y
sbc {z3}
sta {z1}
iny
lda ({z2}),y
sbc {z3}+1
sta {z1}+1