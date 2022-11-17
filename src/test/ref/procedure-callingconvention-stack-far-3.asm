// Test a procedure with calling convention stack
// Recursive fibonacci
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-stack-far-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const STACK_BASE = $103
  .label SCREEN = $400
.segment Code
// __register(A) char fib(__zp(2) char n)
fib: {
    .const OFFSET_STACK_N = 0
    .const OFFSET_STACK_RETURN_0 = 0
    .label __4 = 3
    .label n = 2
    // return n;
    tsx
    lda STACK_BASE+OFFSET_STACK_N,x
    sta.z n
    // if (n == 0 || n == 1)
    beq __b1
    lda #1
    cmp.z n
    beq __b1
    // n-1
    lda.z n
    sec
    sbc #1
    // fib(n-1)
    pha
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    pla
    sta.z __4
    // n-2
    lda.z n
    sec
    sbc #2
    // fib(n-2)
    pha
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    pla
    // return (fib(n-1) + fib(n-2));
    clc
    adc.z __4
  __breturn:
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_0,x
    rts
  __b1:
    lda.z n
    jmp __breturn
}
main: {
    // fib(5)
    lda #5
    pha
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    pla
    // *SCREEN = fib(5)
    sta SCREEN
    // }
    rts
}
