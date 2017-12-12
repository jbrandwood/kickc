lda {zpptrby1}
clc
adc #<{c1}
sta {zpptrby1}
lda {zpptrby1}+1
adc #>{c1}
sta {zpptrby1}+1

