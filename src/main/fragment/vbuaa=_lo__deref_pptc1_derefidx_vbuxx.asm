lda {c1}
sta !+ +1
lda {c1}+1
sta !+ +2
!: lda {c1},x
