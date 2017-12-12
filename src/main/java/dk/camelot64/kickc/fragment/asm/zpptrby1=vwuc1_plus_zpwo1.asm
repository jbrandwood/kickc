lda #<{c1}
clc
adc {zpwo1}
sta {zpptrby1}
lda #>{c1}
adc {zpwo1}+1
sta {zpptrby1}+1
