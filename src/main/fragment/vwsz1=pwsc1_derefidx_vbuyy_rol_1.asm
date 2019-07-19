clc
lda {c1},y
asl
sta {z1}
lda {c1}+1,y
rol
sta {z1}+1

