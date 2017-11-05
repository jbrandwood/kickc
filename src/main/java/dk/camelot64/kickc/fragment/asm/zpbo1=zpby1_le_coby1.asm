lda {zpby1}
cmp #{coby1}
bcc !+
beq !+
lda #0
jmp !++
!: lda #$ff
!: sta {zpbo1}