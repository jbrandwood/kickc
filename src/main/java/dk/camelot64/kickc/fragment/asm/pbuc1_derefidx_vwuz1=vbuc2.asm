lda #<{c1}
clc
adc {z1}
sta !+ +1
lda #>{c1}
adc {z1}+1
sta !+ +2
lda #{c2}
!: sta {c1}
