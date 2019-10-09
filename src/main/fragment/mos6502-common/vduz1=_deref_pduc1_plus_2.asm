clc
lda {c1}
adc #2
sta {z1}
lda {c1}+1
adc #0
sta {z1}+1
lda {c1}+2
adc #0
sta {z1}+2
lda {c1}+3
adc #0
sta {z1}+3
