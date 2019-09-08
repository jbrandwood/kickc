lda {c1},x
clc
adc {c1},y
sta {z1}
lda {c1}+1,x
adc {c1}+1,y
sta {z1}+1
