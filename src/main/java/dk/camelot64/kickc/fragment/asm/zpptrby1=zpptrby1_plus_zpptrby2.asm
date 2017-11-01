lda {zpptrby1}
clc
adc {zpptrby2}
sta {zpptrby1}
lda {zpptrby1}+1
adc {zpptrby2}+1
sta {zpptrby1}+1
