lda {z1}
cmp #{c1}
bcc !+
lda #0
jmp !++
!: lda #$ff
!: sta {zpbo1}
