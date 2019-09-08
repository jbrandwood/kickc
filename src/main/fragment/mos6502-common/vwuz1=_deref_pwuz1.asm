ldy #0
lda ({z1}),y
tax
iny
lda ({z1}),y
sta {z1}+1
stx {z1}
