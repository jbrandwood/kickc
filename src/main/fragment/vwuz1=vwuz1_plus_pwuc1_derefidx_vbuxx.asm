clc
lda {z1}
adc {c1},x
sta {z1}
lda {z1}+1
adc {c1}+1,x
sta {z1}+1
