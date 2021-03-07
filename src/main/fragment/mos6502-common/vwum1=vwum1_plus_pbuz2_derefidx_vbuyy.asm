clc
lda {m1}
adc ({z2}),y
sta {m1}
bcc !+
inc {m1}+1
!: