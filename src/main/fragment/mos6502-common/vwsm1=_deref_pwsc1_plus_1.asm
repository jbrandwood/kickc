clc
lda {c1}
adc #1
sta {m1}
lda {c1}+1
adc #0
sta {m1}+1