lda {z2}
clc
adc #2
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
