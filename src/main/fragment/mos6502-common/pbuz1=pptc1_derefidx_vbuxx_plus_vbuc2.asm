lda {c1},x
clc
adc #{c2}
sta {z1}
lda {c1}+1,x
adc #0
sta {z1}+1