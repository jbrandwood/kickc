lda {zpptrby2}
clc
adc #1
sta {zpptrby1}
lda {zpptrby2}+1
adc #0
sta {zpptrby1}+1