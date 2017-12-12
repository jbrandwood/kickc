lda {z1}
cmp #{coby1}
bcc !+
lda #0
jmp !++
!: lda #$ff
!: sta {zpbo1}
