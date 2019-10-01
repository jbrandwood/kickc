clc
lda {c1},x
adc {c2}
sta {m1}
lda {c1}+1,x
adc {c2}+1
sta {m1}+1

