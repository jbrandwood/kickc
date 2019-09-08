sec
lda {z2}
eor #$ff
adc #$0
sta {z1}
lda {z2}+1
eor #$ff
adc #$0
sta {z1}+1
lda {z2}+2
eor #$ff
adc #$0
sta {z1}+2
lda {z2}+3
eor #$ff
adc #$0
sta {z1}+3