lda {zpwo1}
clc
adc #<{c1}
sta {zpwo1}
lda {zpwo1}+1
adc #>{c1}
sta {zpwo1}+1

