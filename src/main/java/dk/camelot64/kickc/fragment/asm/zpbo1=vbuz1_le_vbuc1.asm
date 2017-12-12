lda {z1}
cmp #{c1}
bcc !+
beq !+
lda #0
jmp !++
!: lda #$ff
!: sta {zpbo1}
