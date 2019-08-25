lda {z1}
clc
adc #1
sta {z1}
bcc !+
inc {z1}+1
!: