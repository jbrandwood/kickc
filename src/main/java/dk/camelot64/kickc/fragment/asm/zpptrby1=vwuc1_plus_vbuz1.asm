lda #<{c1}
clc
adc {z1}
sta {zpptrby1}
lda #>{c1}
adc #0
sta {zpptrby1}+1
