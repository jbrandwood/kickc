lda #<{cowo1}
clc
adc {zpwo1}
sta !+ +1
lda #>{cowo1}
adc {zpwo1}+1
sta !+ +2
lda #{coby2}
!: sta {cowo1}
