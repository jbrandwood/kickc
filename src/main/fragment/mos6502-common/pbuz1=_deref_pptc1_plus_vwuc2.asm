clc
lda {c1}
adc #<{c2}
sta {z1}
lda {c1}+1
adc #>{c2}
sta {z1}+1