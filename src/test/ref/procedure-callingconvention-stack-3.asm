// Test a procedure with calling convention stack
// Test casting of parameter types
// Currently fails because the pushed are done based on the actual value instead of the declared parameter type
// https://gitlab.com/camelot/kickc/issues/319
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    .label _0 = 2
    lda #>'0'
    pha
    lda #<'0'
    pha
    lda #>7
    pha
    lda #<7
    pha
    jsr plus
    pla
    pla
    pla
    sta.z _0
    pla
    sta.z _0+1
    lda.z _0
    sta SCREEN
    lda.z _0+1
    sta SCREEN+1
    rts
}
// plus(word zeropage(2) a, word zeropage(4) b)
plus: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_B = 2
    .const OFFSET_STACK_RETURN = 2
    .label a = 2
    .label b = 4
    .label return = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    lda STACK_BASE+OFFSET_STACK_A+1,x
    sta.z a+1
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    sta.z b
    lda STACK_BASE+OFFSET_STACK_B+1,x
    sta.z b+1
    lda.z return
    clc
    adc.z b
    sta.z return
    lda.z return+1
    adc.z b+1
    sta.z return+1
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN+1,x
    rts
}
