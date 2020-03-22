// Allocates ZP to j/k-variables even though all of i, j, k could be allocates to x and be more efficient.
// Reason: Pass4RegisterUpliftCombinations.isAllocationOverlapping() believes i/j/k variables overlaps insode plot()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label j = 2
    .label k = 3
    ldy #0
  __b1:
    // plot(i)
    tya
    tax
    jsr plot
    // for(byte i : 0..10)
    iny
    cpy #$b
    bne __b1
    lda #0
    sta.z j
  __b2:
    // plot(j)
    ldx.z j
    jsr plot
    // for(byte j : 0..10)
    inc.z j
    lda #$b
    cmp.z j
    bne __b2
    lda #0
    sta.z k
  __b3:
    // plot(k)
    ldx.z k
    jsr plot
    // for(byte k : 0..10)
    inc.z k
    lda #$b
    cmp.z k
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
