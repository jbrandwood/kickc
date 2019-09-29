// Allocates ZP to j/k-variables even though all of i, j, k could be allocates to x and be more efficient.
// Reason: Pass4RegisterUpliftCombinations.isAllocationOverlapping() believes i/j/k variables overlaps insode plot()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    jsr plot
    inx
    cpx #$b
    bne __b1
    ldx #0
  __b2:
    jsr plot
    inx
    cpx #$b
    bne __b2
    ldx #0
  __b3:
    jsr plot
    inx
    cpx #$b
    bne __b3
    rts
}
// plot(byte register(X) x)
plot: {
    lda #'*'
    sta SCREEN,x
    rts
}
