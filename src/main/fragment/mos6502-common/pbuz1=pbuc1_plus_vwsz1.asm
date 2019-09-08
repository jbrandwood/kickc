lda #<{c1}
clc
adc {z1}
sta {z1}
lda #>{c1}
adc {z1}+1
sta {z1}+1 