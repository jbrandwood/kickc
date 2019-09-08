lda {z2}
clc
adc #1
sta {z1}
bcc !+
lda {z2}+1
adc #0
sta {z1}+1
!: