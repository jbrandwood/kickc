lda {c1}
clc
adc #{c2}
sta {c1}
lda {c1}+1
adc #0
sta {c1}+1
