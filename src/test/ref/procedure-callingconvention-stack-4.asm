// Test a procedure with calling convention stack
// A slightly more complex call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    ldy #0
  __b1:
    // v = a+1
    tya
    tax
    inx
    // w = plus('0', v)
    lda #'0'
    pha
    txa
    pha
    jsr plus
    pla
    pla
    // w+a
    sty.z $ff
    clc
    adc.z $ff
    // SCREEN[i] = w+a
    sta SCREEN
    // for(char a:0..1)
    iny
    cpy #2
    bne __b1
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
