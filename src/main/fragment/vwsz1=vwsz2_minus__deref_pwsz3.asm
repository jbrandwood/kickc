sec
lda {z2}
ldy #0
sbc ({z3}),y
sta {z1}
lda {z2}+1
iny
sbc ({z3}),y
sta {z1}+1