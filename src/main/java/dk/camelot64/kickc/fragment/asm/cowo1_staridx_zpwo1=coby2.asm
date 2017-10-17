lda #<{cowo1}
clc
adc {zpwo1}
sta !s+ +1
lda #>{cowo1}
adc {zpwo1}+1
sta !s+ +2
lda #{coby2}
!s: sta {cowo1}
