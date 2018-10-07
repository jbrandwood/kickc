ldy #0
lda ({z1}),y
tax
iny
lda ({z1}),y
stx {z1}
sta {z1}+1