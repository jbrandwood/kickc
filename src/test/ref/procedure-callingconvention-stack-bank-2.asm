// Test a procedure with calling convention stack
// A slightly more complex call
.cpu _65c02
  .segmentdef Program                 [segments="Basic, Code, Data, stage, platform"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef stage                   [start=$0400, min=$0400, max=$07FF, align=$100]
.segmentdef platform                [start=$C000, min=$C000, max=$C7FF, align=$100]

  .const STACK_BASE = $103
  .label SCREEN = $400
  .label i = 4
.segment Code
__start: {
    // char i = 0
    lda #0
    sta.z i
    jsr main
    rts
}
.segment stage
// this should give a pragma error during compile, as test is not declared yet.
// __register(A) char plus(__zp(2) char a, __register(A) char b)
plus: {
    .const OFFSET_STACK_A = 1
    .const OFFSET_STACK_B = 0
    .const OFFSET_STACK_RETURN_1 = 1
    .label a = 2
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    // i++;
    inc.z i
    // return a+b;
    clc
    adc.z a
    // }
    tsx
    sta STACK_BASE+OFFSET_STACK_RETURN_1,x
    rts
}
main: {
    .label a = 3
    lda #0
    sta.z a
  __b1:
    // char v = a+1
    ldx.z a
    inx
    // char w = plus('0', v)
    lda #'0'
    pha
    txa
    pha
    jsr plus
    pla
    pla
    // w+a
    clc
    adc.z a
    // SCREEN[i] = w+a
    ldy.z i
    sta SCREEN,y
    // for(char a:0..1)
    inc.z a
    lda #2
    cmp.z a
    bne __b1
    // }
    rts
}
