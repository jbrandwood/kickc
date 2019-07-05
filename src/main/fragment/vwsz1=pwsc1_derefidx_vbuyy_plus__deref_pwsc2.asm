clc
lda {c1},y
adc {c2}
sta {z1}
lda {c1}+1,y
adc {c2}+1
sta {z1}+1

