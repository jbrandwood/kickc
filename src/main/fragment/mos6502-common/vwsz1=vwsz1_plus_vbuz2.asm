clc
lda {z1}
adc {z2}
sta {z1}
lda {z1}+1
adc #0
sta {z1}+1