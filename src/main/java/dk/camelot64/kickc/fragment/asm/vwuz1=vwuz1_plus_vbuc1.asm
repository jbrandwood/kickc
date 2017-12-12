lda {z1}
clc
adc #<{c1}
sta {z1}
bcc !+
inc {z1}+1
!:
