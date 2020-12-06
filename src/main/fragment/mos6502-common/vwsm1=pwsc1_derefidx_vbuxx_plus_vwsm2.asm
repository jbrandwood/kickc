lda {m2}
clc
adc {c1},x
sta {m1}
lda {m2}+1
adc {c1}+1,x
sta {m1}+1