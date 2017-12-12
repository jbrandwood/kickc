lda #<{cowo1}
clc
adc {z1}
sta {zpptrby1}
lda #>{cowo1}
adc #0
sta {zpptrby1}+1
