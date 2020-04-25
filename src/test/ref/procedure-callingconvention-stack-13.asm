// Test a procedure with calling convention stack
// Recursion that works (no local variables)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    // pow2(6)
    lda #6
    pha
    jsr pow2
    pla
    // *SCREEN = pow2(6)
    sta SCREEN
    // }
    rts
}
// pow2(byte register(A) n)
pow2: {
    .const OFFSET_STACK_N = 0
    .const OFFSET_STACK_RETURN = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_N,x
    // if (n == 0)
    cmp #0
    beq __b1
    // n-1
    sec
    sbc #1
    // pow2(n-1)
    pha
    jsr pow2
    // c = pow2(n-1)
    pla
    // return c+c;
    asl
    jmp __breturn
  __b1:
    lda #1
  __breturn:
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    rts
}
