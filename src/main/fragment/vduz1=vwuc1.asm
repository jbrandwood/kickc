lda #<{c1}
sta {z1}
lda #>{c1}
sta {z1}+1
bmi !m+
lda #0
beq !p+
!m:
lda #$ff
!p:
sta {z1}+2
sta {z1}+3
