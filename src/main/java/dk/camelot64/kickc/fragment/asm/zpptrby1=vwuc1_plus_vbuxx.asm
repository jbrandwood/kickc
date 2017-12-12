txa
clc
adc #<{c1}
sta {zpptrby1}
lda #0
adc #>{c1}
sta {zpptrby1}+1
