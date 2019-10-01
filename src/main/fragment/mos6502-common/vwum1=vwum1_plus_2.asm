lda {m1}
clc
adc #2
sta {m1}
bcc !+
inc {m1}+1
!:
