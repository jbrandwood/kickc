lda {zpptrby1}
sec
sbc #{c1}
sta {zpptrby1}
bcs !+
dec {zpptrby1}+1
!:
