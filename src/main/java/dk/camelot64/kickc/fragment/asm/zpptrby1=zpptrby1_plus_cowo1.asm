lda {zpptrby1}
clc
adc #<{cowo1}
sta {zpptrby1}
lda {zpptrby1}+1
adc #>{cowo1}
sta {zpptrby1}+1

