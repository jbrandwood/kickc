lda #<{c1}
clc
adc {zpwo1}
sta !+ +1
lda #>{c1}
adc {zpwo1}+1
sta !+ +2
lda #{c2}
!: sta {c1}
