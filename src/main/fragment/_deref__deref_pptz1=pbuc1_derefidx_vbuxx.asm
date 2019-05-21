ldy #0
lda {z1}
sta !+ +1
lda {c1},x
!: sta ($ff),y
