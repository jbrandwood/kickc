lda {zpptrby2}
clc
adc #<{c1}
sta {zpptrby1}
lda {zpptrby2}+1
adc #>{c1}
sta {zpptrby1}+1
