// Allocates ZP to j/k-variables even though all of i, j, k could be allocates to x and be more efficient.
// Reason: Pass4RegisterUpliftCombinations.isAllocationOverlapping() believes i/j/k variables overlaps insode plot()
  // Commodore 64 PRG executable file
.file [name="overlap-allocation.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
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
