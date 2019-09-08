ldy #0
sec
lda ({z2}),y
sbc ({z3}),y
sta {z1}
iny
lda ({z2}),y
sbc ({z3}),y
sta {z1}+1
