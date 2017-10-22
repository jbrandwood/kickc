lda {zpptrby1}
sec
sbc #{coby1}
sta {zpptrby1}
bcs !+
dec {zpptrby1}+1
!: