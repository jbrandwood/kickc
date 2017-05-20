lda {zpby1}
cmp #{coby1}
bcc !t+
!f: lda #0
jmp !d+
!t: lda #$ff
!d: sta {zpbo1}