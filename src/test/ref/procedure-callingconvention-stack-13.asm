// Test a procedure with calling convention stack
// Recursion that works (no local variables)
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-13.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
  .label SCREEN = $400
.segment Code
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
