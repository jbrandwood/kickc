ldy #0
!:
lda ({z2}),y
sta ({z1}),y
iny
dex
bne !-