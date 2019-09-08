lda {z2}
clc
adc #<{c1}
sta {z1}
lda {z2}+1
adc #>{c1}
sta {z1}+1
lda {z2}+2
adc #<{c1}>>$10
sta {z1}+2
lda {z2}+3
adc #>{c1}>>$10
sta {z1}+3