lda {c1},y
clc
adc {c1},x
sta {z1}
lda {c1}+1,y
adc {c1}+1,x
sta {z1}+1
