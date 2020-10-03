ldy #0
sec
lda ({z2}),y
sbc {m3}
sta ({z1}),y
iny
lda ({z2}),y
sbc {m3}+1
sta ({z1}),y
