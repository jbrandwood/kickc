clc
lda {m2}
adc #1
sta {m1}
bcc !+
lda {m2}+1
adc #0
sta {m1}+1
!:
