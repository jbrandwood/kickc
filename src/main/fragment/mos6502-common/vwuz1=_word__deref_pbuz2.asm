ldy #0
lda ({z2}),y
sta {z1}
iny
lda #0
sta {z1}+1
