clc
adc {z2}
sta {z1}
lda {z2}+1
adc #0
sta {z1}+1
lda {z2}+2
adc #0
sta {z1}+2
lda {z2}+3
adc #0
sta {z1}+3

