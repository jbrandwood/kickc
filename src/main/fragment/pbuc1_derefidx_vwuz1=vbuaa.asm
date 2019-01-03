sta !v+ +1
lda #<{c1}
clc
adc {z1}
sta !a+ +1
lda #>{c1}
adc {z1}+1
sta !a+ +2
!v: lda #0
!a: sta {c1}
