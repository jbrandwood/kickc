clc
lda {z1}
adc {c1},y
sta {c1},y
lda {z1}+1
adc {c1}+1,y
sta {c1}+1,y
