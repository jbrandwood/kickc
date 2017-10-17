lda #<{cowo1}
clc
adc {zpwo1}
sta {zpptrby1}
lda #>{cowo1}
adc {zpwo1}+1
sta {zpptrby1}+1
