lda {c1},x
clc
adc #1
sta {m1}
lda {c1}+1,x
adc #0
sta {m1}+1

