lda {zpptrby1}
clc
adc #{c1}
sta {zpptrby1}
bcc !+
inc {zpptrby1}+1
!:
