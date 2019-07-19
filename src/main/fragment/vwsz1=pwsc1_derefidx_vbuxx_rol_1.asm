clc
lda {c1},x
asl
sta {z1}
lda {c1}+1,x
rol
sta {z1}+1

