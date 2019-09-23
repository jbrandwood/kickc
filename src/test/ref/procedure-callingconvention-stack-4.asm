// Test a procedure with calling convention stack
// A slightly more complex call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    ldy #0
  b1:
    tya
    tax
    inx
    lda #'0'
    pha
    txa
    pha
    jsr plus
    pla
    pla
    sty.z $ff
    clc
    adc.z $ff
    sta SCREEN
    iny
    cpy #2
    bne b1
    rts
}
// plus(byte zeropage(2) a, byte register(A) b)
plus: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_B = 1
    .const OFFSET_STACK_RETURN = 1
    .label a = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    clc
    adc.z a
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    rts
}
