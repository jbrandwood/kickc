lda {z1}
clc
adc #2
sta {z1}
bcc !+
inc {z2}+1
!: