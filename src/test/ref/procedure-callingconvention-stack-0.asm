// Test a procedure with calling convention stack
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    lda #'0'
    pha
    lda #7
    pha
    jsr plus
    sty SCREEN
    rts
}
// plus(byte zeropage(2) a, byte register(A) b)
plus: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_B = 1
    .label a = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    clc
    adc.z a
    rts
}
