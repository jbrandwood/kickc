// Test a procedure with calling convention stack
// Recursion that works (no local variables)
  .segmentdef Program                 [segments="Basic, Code, Data, stage, platform"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef stage                   [start=$0400, min=$0400, max=$07FF, align=$100]
.segmentdef platform                [start=$C000, min=$C000, max=$C7FF, align=$100]

  .const STACK_BASE = $103
  .label SCREEN = $400
.segment stage
// __register(A) char pow2(__register(A) char n)
pow2: {
    .const OFFSET_STACK_N = 0
    .const OFFSET_STACK_RETURN_0 = 0
    tsx
    lda STACK_BASE+OFFSET_STACK_N,x
    // if (n == 0)
    cmp #0
    beq __b1
    // n-1
    sec
    sbc #1
    // char c = pow2(n-1)
    pha
    jsr pow2
    pla
    // return c+c;
    asl
    jmp __breturn
  __b1:
    lda #1
  __breturn:
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    rts
}
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
