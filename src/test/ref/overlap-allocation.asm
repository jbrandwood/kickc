//  Allocates ZP to j/k-variables even though all of i, j, k could be allocates to x and be more efficient.
//  Reason: Pass4RegisterUpliftCombinations.isAllocationOverlapping() believes i/j/k variables overlaps insode plot()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    jsr plot
    inx
    cpx #$b
    bne b1
    ldx #0
  b2:
    jsr plot
    inx
    cpx #$b
    bne b2
    ldx #0
  b3:
    jsr plot
    inx
    cpx #$b
    bne b3
    rts
}
plot: {
    lda #'*'
    sta SCREEN,x
    rts
}
