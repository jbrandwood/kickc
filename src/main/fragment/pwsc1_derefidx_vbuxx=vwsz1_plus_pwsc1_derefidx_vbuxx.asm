clc
lda {z1}
adc {c1},x
sta {c1},x
lda {z1}+1
adc {c1}+1,x
sta {c1}+1,x
