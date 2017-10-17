lda {zpptrby2}
clc
adc #<{cowo1}
sta {zpptrby1}
lda {zpptrby2}+1
adc #>{cowo1}
sta {zpptrby1}+1
