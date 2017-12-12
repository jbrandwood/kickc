lda {zpwo2}
clc
adc #<{c1}
sta {zpwo1}
lda {zpwo2}+1
adc #0
sta {zpwo1}+1
