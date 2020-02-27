// Test a procedure with calling convention stack
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    // plus('0', 7)
    lda #'0'
    pha
    lda #7
    pha
    jsr plus
    pla
    pla
    // SCREEN[0] = plus('0', 7)
    sta SCREEN
    // }
    rts
}
// plus(byte zp(2) a, byte register(A) b)
plus: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN = 1
    .label a = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // return a+b;
    clc
    adc.z a
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    rts
}
