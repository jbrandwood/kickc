lda #<{c2}
clc
adc {c1}
sta {c1}
lda #>{c2}
adc {c1}+1
sta {c1}+1