txa
clc
adc #<{cowo1}
sta {zpptrby1}
lda #0
adc #>{cowo1}
sta {zpptrby1}+1
