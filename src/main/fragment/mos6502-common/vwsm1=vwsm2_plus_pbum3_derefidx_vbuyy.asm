clc
lda {m2}
adc {m3},y
sta {m1}
lda {m2}+1
adc {m3}+1,y
sta {m1}+1
