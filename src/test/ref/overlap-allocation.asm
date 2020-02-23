// Allocates ZP to j/k-variables even though all of i, j, k could be allocates to x and be more efficient.
// Reason: Pass4RegisterUpliftCombinations.isAllocationOverlapping() believes i/j/k variables overlaps insode plot()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // plot(i)
    jsr plot
    // for(byte i : 0..10)
    inx
    cpx #$b
    bne __b1
    ldx #0
  __b2:
    // plot(j)
    jsr plot
    // for(byte j : 0..10)
    inx
    cpx #$b
    bne __b2
    ldx #0
  __b3:
    // plot(k)
    jsr plot
    // for(byte k : 0..10)
    inx
    cpx #$b
    bne __b3
    // }
    rts
}
// plot(byte register(X) x)
plot: {
    // SCREEN[x] = '*'
    lda #'*'
    sta SCREEN,x
    // }
    rts
}
