lda #{coby1}
clc
adc {zpptrby2}
sta {zpptrby1}
lda #0
adc {zpptrby2}+1
sta {zpptrby1}+1