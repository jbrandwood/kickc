lda #<{c1}
clc
adc {z1}
sta !a1+ +1
lda #>{c1}
adc {z1}+1
sta !a1+ +2
lda #<{c2}
clc
adc {z2}
sta !a2+ +1
lda #>{c2}
adc {z2}+1
sta !a2+ +2
!a2: lda {c2}
!a1: sta {c1}
